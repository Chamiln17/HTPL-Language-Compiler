"""Check docs/*.md against the real compiler.

usage: python3 tests/check_docs.py <repo> <htplc>   (run by `make test-docs`)
- ```htpl block with <program>: htplc must accept it.
- ```htpl block without <program>: must be a contiguous run of lines of examples/test.htpl (whitespace-trimmed).
- ```text block with <program>: htplc must reject it.
- every relative markdown link must resolve to an existing file.
"""
import re, subprocess, sys, pathlib, urllib.parse

repo, htplc = pathlib.Path(sys.argv[1]), sys.argv[2]
docs = [repo / "docs/language.md", repo / "docs/architecture.md"]
example = [l.strip() for l in (repo / "examples/test.htpl").read_text().splitlines()]
fails = n = 0

def accepted(src):
    p = subprocess.run([htplc], input=src, capture_output=True, text=True)
    return p.returncode == 0 and "\nParsing successful\n" in "\n" + p.stdout

def in_example(src):
    lines = [l.strip() for l in src.splitlines() if l.strip()]
    return any(example[i:i + len(lines)] == lines for i in range(len(example)))

for doc in docs:
    if not doc.exists():
        print(f"FAIL missing {doc}"); fails += 1; continue
    text = doc.read_text(encoding="utf-8")
    for lang, body in re.findall(r"^[ ]*```(\w*)\n(.*?)^[ ]*```", text, re.M | re.S):
        if lang == "htpl":
            n += 1
            if "<program>" in body:
                ok, why = accepted(body), "accepted"
            else:
                ok, why = in_example(body), "in examples/test.htpl"
        elif lang == "text" and "<program>" in body:
            n += 1
            ok, why = not accepted(body), "rejected"
        else:
            continue
        print(f"{'ok  ' if ok else 'FAIL'} {doc.name}: {why}: {body.splitlines()[0][:50]!r}...")
        fails += not ok
    for target in re.findall(r"\]\(([^)\s]+)\)", text):
        if re.match(r"[a-z]+:|#", target):
            continue
        path = (doc.parent / urllib.parse.unquote(target.split("#")[0])).resolve()
        ok = path.exists()
        print(f"{'ok  ' if ok else 'FAIL'} {doc.name}: link {target}")
        fails += not ok

print(f"{n} snippets checked, {fails} failures")
sys.exit(1 if fails or n == 0 else 0)
