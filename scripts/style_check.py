import re
import sys
from pathlib import Path


def show_matches(title: str, pattern: str, text: str) -> None:
    print()
    print(title)
    matches = list(re.finditer(pattern, text, flags=re.MULTILINE))
    if not matches:
        print("OK")
        return
    lines = text.splitlines()
    offsets = []
    total = 0
    for line in lines:
        offsets.append(total)
        total += len(line) + 1
    for m in matches:
        line_no = text.count("\n", 0, m.start()) + 1
        print(f"{line_no}:{lines[line_no - 1]}")


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

    show_matches("[1] body list lines", r"^\s*([-*+]\s+|[0-9]+\.\s+)", text)
    show_matches(
        "[2] bold inline labels",
        r"\*\*技术描述\*\*|\*\*技术难点\*\*|\*\*作用\*\*|\*\*预期输出\*\*|\*\*预期成果\*\*|\*\*关键点\*\*|\*\*子课题",
        text,
    )
    show_matches("[3] mechanical transitions", r"首先|其次|最后|此外|另外|接下来|总之", text)
    show_matches("[4] empty emphasis phrases", r"值得注意的是|需要指出的是|重要的是|必须强调的是", text)
    show_matches("[5] dense outline numbering", r"^[0-9]+\.[0-9]+(\.[0-9]+)?\s", text)

    print()
    print("Done.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
