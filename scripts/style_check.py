import re
import sys
from pathlib import Path


def show_matches(title: str, pattern: str, text: str) -> int:
    print()
    print(title)
    matches = list(re.finditer(pattern, text, flags=re.MULTILINE))
    if not matches:
        print("OK")
        return 0
    lines = text.splitlines()
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

    text = path.read_text(encoding="utf-8")
    print(f"Checking: {path}")

    counts = {}
    counts["body_list"] = show_matches("[1] body list lines", r"^\s*([-*+]\s+|[0-9]+\.\s+)", text)
    counts["bold_labels"] = show_matches(
        "[2] bold inline labels",
        r"\*\*技术描述\*\*|\*\*技术难点\*\*|\*\*作用\*\*|\*\*预期输出\*\*|\*\*预期成果\*\*|\*\*关键点\*\*|\*\*子课题",
        text,
    )
    counts["transitions"] = show_matches("[3] mechanical transitions", r"首先|其次|最后|此外|另外|接下来|总之", text)
    counts["empty_emphasis"] = show_matches("[4] empty emphasis phrases", r"值得注意的是|需要指出的是|重要的是|必须强调的是", text)
    counts["dense_numbering"] = show_matches("[5] dense outline numbering", r"^[0-9]+\.[0-9]+(\.[0-9]+)?\s", text)
    counts["slogans"] = show_matches(
        "[6] shallow slogan phrases",
        r"赋能|打造.*平台|构建.*体系|形成.*闭环|显著提升|大幅提升|全面提升|达到先进水平|推动高质量发展",
        text,
    )

    print()
    print(
        "Summary: "
        + ", ".join(f"{name}={count}" for name, count in counts.items())
    )
    hard_fail = counts["body_list"] or counts["bold_labels"] or counts["empty_emphasis"] or counts["dense_numbering"]
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
