import re
import sys
from pathlib import Path


def strip_ignored_blocks(text: str) -> str:
    """Blank fenced code blocks and Markdown tables while preserving line numbers."""
    cleaned = []
    in_fence = False
    for line in text.splitlines():
        stripped = line.strip()
        if stripped.startswith("```"):
            in_fence = not in_fence
            cleaned.append("")
            continue
        if in_fence or stripped.startswith("|"):
            cleaned.append("")
            continue
        cleaned.append(line)
    return "\n".join(cleaned)


def show_matches(title: str, pattern: str, text: str, display_text: str | None = None) -> int:
    print()
    print(title)
    matches = list(re.finditer(pattern, text, flags=re.MULTILINE))
    if not matches:
        print("OK")
        return 0
    lines = (display_text or text).splitlines()
    offsets = []
    total = 0
    for line in lines:
        offsets.append(total)
        total += len(line) + 1
    for m in matches:
        line_no = text.count("\n", 0, m.start()) + 1
        print(f"{line_no}:{lines[line_no - 1]}")
    return len(matches)


def main() -> int:
    if len(sys.argv) != 2:
        print("Usage: python scripts/style_check.py <file>")
        return 1

    path = Path(sys.argv[1])
    if not path.exists():
        print(f"File not found: {path}")
        return 1

    raw_text = path.read_text(encoding="utf-8")
    text = strip_ignored_blocks(raw_text)
    print(f"Checking: {path}")

    counts = {}
    counts["body_list"] = show_matches("[1] body list lines", r"^\s*([-*+]\s+|[0-9]+\.\s+)", text, raw_text)
    counts["bold_labels"] = show_matches(
        "[2] bold inline labels",
        r"\*\*技术描述\*\*|\*\*技术难点\*\*|\*\*作用\*\*|\*\*预期输出\*\*|\*\*预期成果\*\*|\*\*关键点\*\*|\*\*子课题",
        text,
        raw_text,
    )
    counts["transitions"] = show_matches("[3] mechanical transitions", r"首先|其次|最后|此外|另外|接下来|总之", text, raw_text)
    counts["empty_emphasis"] = show_matches("[4] empty emphasis phrases", r"值得注意的是|需要指出的是|重要的是|必须强调的是", text, raw_text)
    counts["dense_numbering"] = show_matches("[5] dense outline numbering", r"^[0-9]+\.[0-9]+(\.[0-9]+)?\s", text, raw_text)
    counts["slogans"] = show_matches(
        "[6] shallow slogan phrases",
        r"赋能|打造.*平台|构建.*体系|形成.*闭环|显著提升|大幅提升|全面提升|达到先进水平|推动高质量发展",
        text,
        raw_text,
    )
    counts["chapter_heading_style"] = show_matches(
        "[7] report heading uses chapter label",
        r"^#\s*第[一二三四五六七八九十0-9]+章",
        text,
        raw_text,
    )
    counts["markdown_decimal_heading"] = show_matches(
        "[8] markdown heading uses decimal outline",
        r"^#{2,6}\s+[0-9]+\.[0-9]+",
        text,
        raw_text,
    )

    print()
    print(
        "Summary: "
        + ", ".join(f"{name}={count}" for name, count in counts.items())
    )
    hard_fail = (
        counts["body_list"]
        or counts["bold_labels"]
        or counts["empty_emphasis"]
        or counts["dense_numbering"]
        or counts["chapter_heading_style"]
        or counts["markdown_decimal_heading"]
    )
    if hard_fail:
        print("Result: FAIL")
        print("Done.")
        return 2
    if counts["transitions"] >= 5:
        print("Result: FAIL")
        print("Done.")
        return 2
    if counts["slogans"]:
        print("Result: WARN")
        print("Done.")
        return 0
    print("Result: OK")
    print("Done.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
