# -*- coding: utf-8 -*-
"""Count Chinese characters in markdown drafts.

The official-doc skills use this as a deterministic preflight before review
and assembly. It intentionally excludes tables, fenced code blocks and
blockquote-only lines, because those are not counted as正文厚度 in the review
rules.
"""

from __future__ import annotations

import argparse
import json
import re
from pathlib import Path


CHINESE_RE = re.compile(r"[\u4e00-\u9fff]")
CHAPTER_RE = re.compile(r"^#{1,2}\s*(.+?)\s*$")
OFFICIAL_CHAPTER_RE = re.compile(
    r"^(?:[一二三四五六七八九十]+、|第[一二三四五六七八九十0-9]+章\b)"
)


def count_chinese(text: str) -> int:
    return len(CHINESE_RE.findall(text))


def iter_countable_lines(text: str):
    in_code = False
    for line in text.splitlines():
        stripped = line.strip()
        if stripped.startswith("```"):
            in_code = not in_code
            continue
        if in_code:
            continue
        if not stripped:
            continue
        if stripped.startswith("|") or stripped.startswith(">"):
            continue
        yield line


def normalize_heading(line: str) -> str | None:
    match = CHAPTER_RE.match(line.strip())
    if not match:
        return None
    heading = match.group(1).strip()
    if OFFICIAL_CHAPTER_RE.match(heading):
        return heading
    return None


def count_file(path: Path) -> dict:
    text = path.read_text(encoding="utf-8")
    total = 0
    chapters: list[dict] = []
    current: dict | None = None

    for line in iter_countable_lines(text):
        heading = normalize_heading(line)
        line_count = count_chinese(line)
        total += line_count

        if heading is not None:
            current = {"title": heading, "chars": line_count}
            chapters.append(current)
            continue

        if current is not None:
            current["chars"] += line_count

    return {
        "file": str(path),
        "total_chinese_chars": total,
        "chapters": chapters,
    }


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("files", nargs="+", help="Markdown files to count")
    parser.add_argument("--json", action="store_true", help="Emit JSON")
    args = parser.parse_args()

    results = [count_file(Path(item)) for item in args.files]

    if args.json:
        print(json.dumps(results, ensure_ascii=False, indent=2))
        return 0

    for result in results:
        print(f"File: {result['file']}")
        print(f"Total Chinese chars: {result['total_chinese_chars']}")
        for chapter in result["chapters"]:
            print(f"- {chapter['title']}: {chapter['chars']}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
