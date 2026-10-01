#!/usr/bin/env python3
"""Regenerate the exercise tables in the published documentation.

`docs/exercises.md` and `docs/en/exercises.md` keep their prose, but the block
between the marker comments is generated from `exercises/manifest.json`, so the
published curriculum cannot drift from the manifest. CI regenerates the tables
and fails on any diff.

The block is emitted as HTML rather than a Markdown table: the block sits next
to HTML comments, and kramdown silently stops recognising a Markdown table
there. HTML renders identically in Jekyll and on GitHub.
"""

import html
import json
import re
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
MANIFEST = ROOT / "exercises" / "manifest.json"
GUIDE_URL = "https://github.com/snorfyang/moonbitlings/blob/main/guides/{}.md"
BEGIN = "<!-- BEGIN GENERATED EXERCISE TABLE -->"
END = "<!-- END GENERATED EXERCISE TABLE -->"

# Exercise-id prefixes per topic, matching guides/README.md.
TOPICS = [
    (["00"], "getting-started", "入门", "Getting started"),
    (
        [f"{index:02d}" for index in range(1, 5)],
        "functions",
        "表达式与函数",
        "Expressions and functions",
    ),
    (["05", "06"], "data-types", "struct、枚举与模式匹配", "Structs, enums, and patterns"),
    (
        ["07", "08"] + [f"{index:02d}" for index in range(20, 26)],
        "options-and-errors",
        "缺失值与错误处理",
        "Missing values and errors",
    ),
    (["09", "10"], "generics-and-traits", "泛型与 trait", "Generics and traits"),
    (["11", "12"], "arrays", "数组与回调", "Arrays and callbacks"),
    (["13", "14", "15"], "strings", "字符串与字符", "Strings and characters"),
    (["16", "17", "18"], "collections", "Map 与 Set", "Maps and sets"),
    (["19"], "review", "综合复习", "Review"),
    (
        [f"{index:02d}" for index in range(26, 29)],
        "packages",
        "包与可见性",
        "Packages and visibility",
    ),
]

HEADERS = {
    "zh": (("练习", "标题", "类型", "主题"), "共 {count} 道练习。"),
    "en": (("Exercise", "Title", "Kind", "Topic"), "{count} exercises."),
}


def topic_by_prefix() -> dict[str, tuple[str, str, str]]:
    table: dict[str, tuple[str, str, str]] = {}
    for prefixes, guide, zh, en in TOPICS:
        for prefix in prefixes:
            if prefix in table:
                raise ValueError(f"duplicate topic prefix: {prefix}")
            table[prefix] = (guide, zh, en)
    return table


def render(language: str, exercises: list[dict[str, str]]) -> str:
    topics = topic_by_prefix()
    cells, summary = HEADERS[language]
    rows = []
    for exercise in exercises:
        exercise_id = exercise["id"]
        topic = topics.get(exercise_id[:2])
        if topic is None:
            raise ValueError(f"no topic for exercise: {exercise_id}")
        guide, zh, en = topic
        label = zh if language == "zh" else en
        rows.append(
            "<tr>"
            f"<td><code>{html.escape(exercise_id)}</code></td>"
            f"<td>{html.escape(exercise['title'])}</td>"
            f"<td><code>{html.escape(exercise['kind'])}</code></td>"
            f'<td><a href="{GUIDE_URL.format(guide)}">{html.escape(label)}</a></td>'
            "</tr>"
        )
    header = "".join(f"<th>{html.escape(cell)}</th>" for cell in cells)
    return "\n".join(
        [
            f"<p>{summary.format(count=len(exercises))}</p>",
            "",
            "<table>",
            "<thead>",
            f"<tr>{header}</tr>",
            "</thead>",
            "<tbody>",
            *rows,
            "</tbody>",
            "</table>",
        ]
    )


def rewrite(path: Path, block: str) -> bool:
    text = path.read_text(encoding="utf-8")
    pattern = re.compile(re.escape(BEGIN) + r".*?" + re.escape(END), re.DOTALL)
    if not pattern.search(text):
        raise ValueError(f"{path} is missing the generated-table markers")
    updated = pattern.sub(f"{BEGIN}\n\n{block}\n\n{END}", text)
    if updated == text:
        return False
    path.write_text(updated, encoding="utf-8")
    return True


def main() -> int:
    exercises = json.loads(MANIFEST.read_text())["exercises"]
    changed = False
    for language, relative in (("zh", "docs/exercises.md"), ("en", "docs/en/exercises.md")):
        path = ROOT / relative
        if not path.is_file():
            print(f"missing documentation page: {relative}", file=sys.stderr)
            return 1
        changed |= rewrite(path, render(language, exercises))
    print("updated exercise tables" if changed else "exercise tables are up to date")
    return 0


if __name__ == "__main__":
    sys.exit(main())
