import csv
import io
import json
import tempfile
import unittest
from contextlib import redirect_stdout
from pathlib import Path

from tool import generate_ledger_per_asset as ledger


class LedgerAuditTests(unittest.TestCase):
    def setUp(self):
        self.temp_dir = tempfile.TemporaryDirectory()
        root = Path(self.temp_dir.name)
        self.original_manifest = ledger.MANIFEST
        self.original_csv_path = ledger.CSV_PATH
        ledger.MANIFEST = root / "assets_manifest.json"
        ledger.CSV_PATH = root / "ledger.csv"

    def tearDown(self):
        ledger.MANIFEST = self.original_manifest
        ledger.CSV_PATH = self.original_csv_path
        self.temp_dir.cleanup()

    def write_manifest(self, paths):
        ledger.MANIFEST.write_text(
            json.dumps({"assets": [{"path": path} for path in paths]}),
            encoding="utf-8",
        )

    @staticmethod
    def row(path):
        row = {field: "recorded" for field in ledger.HEADER}
        row["path"] = path
        return row

    def write_csv(self, rows, fieldnames=None):
        fieldnames = fieldnames or ledger.HEADER
        with ledger.CSV_PATH.open("w", newline="", encoding="utf-8-sig") as fh:
            writer = csv.DictWriter(fh, fieldnames=fieldnames)
            writer.writeheader()
            writer.writerows(rows)

    def audit(self):
        with redirect_stdout(io.StringIO()):
            return ledger.audit()

    def test_audit_accepts_exact_manifest_coverage(self):
        self.write_manifest(["a.png", "b.png"])
        self.write_csv([self.row("a.png"), self.row("b.png")])

        self.assertEqual(self.audit(), 0)

    def test_audit_rejects_duplicate_paths(self):
        self.write_manifest(["a.png", "b.png"])
        self.write_csv([self.row("a.png"), self.row("b.png"), self.row("a.png")])

        self.assertEqual(self.audit(), 1)

    def test_audit_rejects_paths_outside_manifest(self):
        self.write_manifest(["a.png", "b.png"])
        self.write_csv(
            [self.row("a.png"), self.row("b.png"), self.row("extra.png")]
        )

        self.assertEqual(self.audit(), 1)

    def test_audit_rejects_paths_with_surrounding_whitespace(self):
        self.write_manifest(["a.png"])
        self.write_csv([self.row("a.png ")])

        self.assertEqual(self.audit(), 1)

    def test_audit_rejects_missing_columns(self):
        self.write_manifest(["a.png"])
        fields = [field for field in ledger.HEADER if field != "operator"]
        row = {field: "recorded" for field in fields}
        row["path"] = "a.png"
        self.write_csv([row], fieldnames=fields)

        self.assertEqual(self.audit(), 1)

    def test_unknown_batch_uses_the_csv_schema(self):
        row = ledger.batch_for("unclassified/new.png")

        self.assertEqual(set(row), set(ledger.HEADER) - {"path"})
        self.assertEqual(row["batch_date"], "未知")


if __name__ == "__main__":
    unittest.main()
