import re
import sys
from pathlib import Path


GRAPH_HEADER_RE = re.compile(
    r"^\s*(?:flowchart|graph|sequenceDiagram|classDiagram|erDiagram|gantt|journey|mindmap|timeline|stateDiagram(?:-v2)?)\b"
)


def main() -> int:
    if len(sys.argv) != 2:
        print("Usage: python scripts/check_mermaid.py <file.mmd>")
        return 1

    path = Path(sys.argv[1])
    if not path.exists():
        print(f"File not found: {path}")
        return 1

    text = path.read_text(encoding="utf-8")
    lines = text.splitlines()

    print(f"Checking Mermaid: {path}")

    errors: list[tuple[int, str]] = []

    first_nonempty = next((line for line in lines if line.strip()), "")
    if not GRAPH_HEADER_RE.match(first_nonempty):
        errors.append((1, "missing or invalid Mermaid graph header"))

    subgraph_stack: list[int] = []

    for line_no, line in enumerate(lines, start=1):
        stripped = line.strip()
        if not stripped:
            continue

        if re.search(r"\bend\s+subgraph", stripped):
            errors.append((line_no, "`end` must be on its own line; do not write `end subgraph...`"))

        if re.search(r"\]\s+end\b", stripped) or re.search(r'"\s+end\b', stripped):
            errors.append((line_no, "node definition and `end` must not appear on the same line"))

        if stripped.startswith("subgraph"):
            subgraph_stack.append(line_no)
            continue

        if re.fullmatch(r"end", stripped):
            if not subgraph_stack:
                errors.append((line_no, "unexpected `end` without matching `subgraph`"))
            else:
                subgraph_stack.pop()
            continue

        if re.search(r"\bend\b", stripped) and stripped != "end":
            if "end" in stripped.lower():
                errors.append((line_no, "`end` appears with extra tokens; keep it on a standalone line"))

    for start_line in subgraph_stack:
        errors.append((start_line, "unclosed `subgraph` block"))

    if errors:
        print("Errors:")
        for line_no, message in errors:
            preview = lines[line_no - 1] if 0 < line_no <= len(lines) else ""
            print(f"{line_no}: {message}")
            if preview:
                print(f"    {preview}")
        print("Result: FAIL")
        return 2

    print("Result: OK")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
