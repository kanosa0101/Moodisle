#!/usr/bin/env python3
"""Render Moodisle's short UI sounds with deterministic standard-library synthesis."""

from __future__ import annotations

import math
import random
import struct
import wave
from pathlib import Path


SAMPLE_RATE = 44_100
TARGET_PEAK = 0.55
REPO_ROOT = Path(__file__).resolve().parents[1]
SOURCE_DIR = REPO_ROOT / "assets-src" / "audio" / "original"
RUNTIME_DIR = REPO_ROOT / "app" / "assets" / "audio"


def _tone(
    samples: list[float],
    start: float,
    duration: float,
    frequency: float,
    *,
    amplitude: float = 0.3,
    decay: float = 8.0,
    partials: tuple[float, ...] = (1.0, 0.28, 0.10),
    vibrato: float = 0.0,
) -> None:
    begin = max(0, round(start * SAMPLE_RATE))
    count = min(len(samples) - begin, round(duration * SAMPLE_RATE))
    if count <= 0:
        return
    for index in range(count):
        t = index / SAMPLE_RATE
        attack = min(1.0, t / 0.003)
        envelope = attack * math.exp(-decay * t)
        phase = 2.0 * math.pi * frequency * t
        if vibrato:
            phase += vibrato * math.sin(2.0 * math.pi * 5.5 * t)
        value = 0.0
        for harmonic, weight in enumerate(partials, start=1):
            value += weight * math.sin(phase * harmonic)
        samples[begin + index] += amplitude * envelope * value


def _sweep(
    samples: list[float],
    start: float,
    duration: float,
    low_hz: float,
    high_hz: float,
    *,
    amplitude: float,
    decay: float = 5.0,
) -> None:
    begin = max(0, round(start * SAMPLE_RATE))
    count = min(len(samples) - begin, round(duration * SAMPLE_RATE))
    if count <= 0:
        return
    phase = 0.0
    ratio = high_hz / low_hz
    for index in range(count):
        t = index / SAMPLE_RATE
        progress = t / duration
        frequency = low_hz * ratio**progress
        phase += 2.0 * math.pi * frequency / SAMPLE_RATE
        attack = min(1.0, t / 0.008)
        release = max(0.0, 1.0 - progress) ** 1.5
        samples[begin + index] += amplitude * attack * release * math.sin(phase)


def _soft_noise(
    samples: list[float],
    rng: random.Random,
    start: float,
    duration: float,
    *,
    amplitude: float,
    high_pass: bool = False,
    rise: bool = False,
) -> None:
    begin = max(0, round(start * SAMPLE_RATE))
    count = min(len(samples) - begin, round(duration * SAMPLE_RATE))
    if count <= 0:
        return
    previous = 0.0
    smoothed = 0.0
    coefficient = 0.16
    for index in range(count):
        t = index / SAMPLE_RATE
        progress = t / duration
        raw = rng.uniform(-1.0, 1.0)
        smoothed += coefficient * (raw - smoothed)
        noise = raw - previous if high_pass else smoothed
        previous = raw
        attack = min(1.0, t / 0.002)
        envelope = (progress if rise else 1.0 - progress) * attack
        samples[begin + index] += amplitude * envelope * noise


def _render(name: str, seed: int) -> tuple[float, list[float]]:
    rng = random.Random(seed)
    specs: dict[
        str,
        tuple[
            float,
            list[tuple[float, float, float, float, float, tuple[float, ...]]],
        ],
    ] = {
        "tap": (0.075, [(0.0, 0.075, 470.0, 0.44, 55.0, (1.0, 0.72, 0.28))]),
        "add": (0.29, [(0.0, 0.23, 659.25, 0.28, 9.0, (1.0, 0.44, 0.12)), (0.085, 0.20, 880.0, 0.25, 10.0, (1.0, 0.38, 0.10))]),
        "complete": (0.55, [(0.0, 0.36, 523.25, 0.23, 7.0, (1.0, 0.40, 0.12)), (0.12, 0.38, 659.25, 0.22, 7.5, (1.0, 0.38, 0.10)), (0.24, 0.42, 783.99, 0.21, 8.0, (1.0, 0.32, 0.09))]),
        "capture": (0.74, [(0.0, 0.42, 523.25, 0.22, 7.0, (1.0, 0.38, 0.12)), (0.12, 0.43, 659.25, 0.21, 7.0, (1.0, 0.34, 0.10)), (0.24, 0.45, 783.99, 0.20, 7.0, (1.0, 0.32, 0.10)), (0.36, 0.48, 1046.5, 0.19, 7.5, (1.0, 0.28, 0.08))]),
        "evolve": (0.96, [(0.0, 0.43, 392.0, 0.21, 6.5, (1.0, 0.40, 0.14)), (0.14, 0.45, 493.88, 0.20, 6.5, (1.0, 0.38, 0.12)), (0.28, 0.47, 587.33, 0.20, 6.5, (1.0, 0.34, 0.11)), (0.42, 0.47, 783.99, 0.19, 7.0, (1.0, 0.32, 0.10)), (0.56, 0.42, 987.77, 0.18, 7.0, (1.0, 0.30, 0.09))]),
        "light": (0.51, [(0.0, 0.34, 783.99, 0.22, 8.0, (1.0, 0.32, 0.08)), (0.11, 0.36, 987.77, 0.21, 8.0, (1.0, 0.28, 0.07)), (0.22, 0.38, 1174.66, 0.19, 8.5, (1.0, 0.24, 0.06))]),
        "loot": (0.39, [(0.0, 0.27, 587.33, 0.24, 12.0, (1.0, 0.52, 0.24, 0.11)), (0.105, 0.28, 880.0, 0.22, 13.0, (1.0, 0.46, 0.18, 0.08))]),
        "levelup": (0.82, [(0.0, 0.52, 261.63, 0.21, 5.4, (1.0, 0.55, 0.34, 0.20)), (0.16, 0.53, 329.63, 0.20, 5.6, (1.0, 0.52, 0.30, 0.17)), (0.32, 0.54, 392.0, 0.20, 5.8, (1.0, 0.48, 0.28, 0.15)), (0.48, 0.55, 523.25, 0.19, 6.0, (1.0, 0.44, 0.24, 0.13))]),
        "error": (0.24, [(0.0, 0.18, 155.56, 0.31, 13.0, (1.0, 0.24, 0.08))]),
        "glance": (0.36, [(0.0, 0.20, 659.25, 0.19, 11.0, (1.0, 0.30, 0.08)), (0.13, 0.22, 830.61, 0.18, 11.0, (1.0, 0.28, 0.07))]),
    }
    if name not in specs:
        raise ValueError(f"Unknown sound: {name}")
    duration, notes = specs[name]
    samples = [0.0] * round(duration * SAMPLE_RATE)
    for start, note_duration, frequency, amplitude, decay, partials in notes:
        _tone(samples, start, note_duration, frequency, amplitude=amplitude, decay=decay, partials=partials)

    if name == "tap":
        _soft_noise(samples, rng, 0.0, duration, amplitude=0.12, high_pass=True)
    elif name in {"complete", "capture", "light"}:
        for offset in ((0.20, 0.32, 0.40) if name == "capture" else (0.28, 0.37) if name == "complete" else (0.26, 0.33)):
            _soft_noise(samples, rng, offset, 0.055, amplitude=0.055, high_pass=True)
    elif name == "evolve":
        _sweep(samples, 0.0, 0.84, 150.0, 1150.0, amplitude=0.09)
        _soft_noise(samples, rng, 0.08, 0.72, amplitude=0.07, high_pass=True, rise=True)
    elif name == "loot":
        _soft_noise(samples, rng, 0.0, 0.11, amplitude=0.09, high_pass=True)
    elif name == "error":
        _sweep(samples, 0.0, 0.16, 260.0, 130.0, amplitude=0.18)
        _soft_noise(samples, rng, 0.0, 0.045, amplitude=0.10)
    elif name == "glance":
        _sweep(samples, 0.0, 0.29, 620.0, 890.0, amplitude=0.055)

    peak = max(abs(sample) for sample in samples)
    if peak:
        scale = TARGET_PEAK / peak
        samples = [sample * scale for sample in samples]
    return duration, samples


SEEDS = {
    "tap": 2026092801,
    "add": 2026092802,
    "complete": 2026092803,
    "capture": 2026092804,
    "evolve": 2026092805,
    "light": 2026092806,
    "loot": 2026092807,
    "levelup": 2026092808,
    "error": 2026092809,
    "glance": 2026092810,
}


def _wav_bytes(samples: list[float]) -> bytes:
    pcm = b"".join(
        struct.pack("<h", max(-32768, min(32767, round(sample * 32767))))
        for sample in samples
    )
    from io import BytesIO

    stream = BytesIO()
    with wave.open(stream, "wb") as audio:
        audio.setnchannels(1)
        audio.setsampwidth(2)
        audio.setframerate(SAMPLE_RATE)
        audio.writeframes(pcm)
    return stream.getvalue()


def _write_if_unchanged(path: Path, content: bytes) -> None:
    if path.exists():
        if path.read_bytes() != content:
            raise FileExistsError(f"Refusing to overwrite a different file: {path}")
        return
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_bytes(content)


def main() -> None:
    SOURCE_DIR.mkdir(parents=True, exist_ok=True)
    RUNTIME_DIR.mkdir(parents=True, exist_ok=True)
    for name, seed in SEEDS.items():
        _, samples = _render(name, seed)
        content = _wav_bytes(samples)
        source = SOURCE_DIR / f"{name}.wav"
        runtime = RUNTIME_DIR / f"{name}.wav"
        _write_if_unchanged(source, content)
        _write_if_unchanged(runtime, content)
        print(f"{name}: {len(samples) / SAMPLE_RATE:.3f}s, seed={seed}, {len(content)} bytes")


if __name__ == "__main__":
    main()
