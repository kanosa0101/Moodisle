# -*- coding: utf-8 -*-
"""覆盖率报告：解析 lcov.info 输出总体与 domain 覆盖率。"""
import io
import re

lcov = io.open('coverage/lcov.info', encoding='utf-8').read()
records = re.findall(r'SF:(.*?)\n((?:DA:\d+,\d+\n)+)', lcov)
agg = {}
for path, das in records:
    key = path.replace(chr(92), '/')
    hits = [int(h) for _, h in re.findall(r'DA:(\d+),(\d+)', das)]
    a = agg.setdefault(key, [0, 0])
    a[1] += len(hits)
    a[0] += sum(1 for h in hits if h > 0)


def pct(items):
    hit = sum(v[0] for _, v in items)
    total = sum(v[1] for _, v in items)
    pct_val = hit * 100 // total if total else 0
    return pct_val, hit, total


all_items = sorted(agg.items())
dom_items = [(k, v) for k, v in all_items if '/domain/' in k]
p_all = pct(all_items)
p_dom = pct(dom_items)
print('总体行覆盖率: %d%% (%d/%d)' % p_all)
print('domain 覆盖率: %d%% (%d/%d)' % p_dom)
