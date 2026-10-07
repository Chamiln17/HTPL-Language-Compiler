"""Check README.md and README.fr.md against the repo and the real compiler.

usage: python3 tests/check_readme.py <repo> <htplc> [credits.md]   (run by `make test-docs`)
The credits checks run only when the owner's local credits note is given (it is not in the repo).
- every ```text block that contains "=== Quadruplets ===" is a contiguous substring of examples/test.expected
- every ```htpl block with <program> is accepted by htplc
- every relative link and image resolves to an existing file
- with a credits note: course line and team (in order) appear verbatim
- a "Current limitations" section with 1-4 bullets links to docs/language.md#limitations
- README.fr.md: same heading structure, identical non-Mermaid code blocks, links/image resolve,
  names exact and in order, and each README links to the other in its first lines
"""
import re, subprocess, sys, pathlib, urllib.parse

repo, htplc = pathlib.Path(sys.argv[1]), sys.argv[2]
credits = pathlib.Path(sys.argv[3]) if len(sys.argv) > 3 else None
text = (repo / "README.md").read_text(encoding="utf-8")
expected = (repo / "examples/test.expected").read_text(encoding="utf-8")
fails = 0

def check(ok, what):
    global fails
    print(f"{'ok  ' if ok else 'FAIL'} {what}")
    fails += not ok

blocks = re.findall(r"^```(\w*)\n(.*?)^```", text, re.M | re.S)
samples = [b for lang, b in blocks if lang == "text" and "=== Quadruplets ===" in b]
check(len(samples) == 1, "one sample-output block")
for b in samples:
    check(b in expected, "sample output is a contiguous excerpt of examples/test.expected")

progs = [b for lang, b in blocks if lang == "htpl" and "<program>" in b]
check(len(progs) >= 1, "sample HTPL program present")
for b in progs:
    p = subprocess.run([htplc], input=b, capture_output=True, text=True)
    check(p.returncode == 0 and "\nParsing successful\n" in "\n" + p.stdout, "sample program accepted by htplc")

check(any(lang == "mermaid" for lang, _ in blocks), "mermaid block present")

for target in re.findall(r"\]\(([^)\s]+)\)", text) + re.findall(r'src="([^"]+)"', text):
    if re.match(r"[a-z]+:|#", target):
        continue
    check((repo / urllib.parse.unquote(target.split("#")[0])).exists(), f"link {target}")
check("docs/assets/htpl.webp" in text.split("\n## ")[0], "logo at the top")

team = []
if credits:
    c = credits.read_text(encoding="utf-8")
    course = re.search(r'Course line: "([^"]+)"', c).group(1)
    team = re.search(r"no roles: (.+)", c).group(1).split(", ")
    right, wrong = re.search(r'Spelling: "(\w+)" \(not "(\w+)"', c).groups()
    check(course in text, "course line verbatim")
    pos = [text.find(n) for n in team]
    check(all(p >= 0 for p in pos) and pos == sorted(pos), "team verbatim, alphabetical order")
    check(wrong not in text, "no misspelled owner name")

lim = text.split("## Current limitations")[1].split("\n## ")[0] if "## Current limitations" in text else ""
bullets = [l for l in lim.splitlines() if l.startswith("- ")]
check(1 <= len(bullets) <= 4, f"1-4 limitation bullets ({len(bullets)})")
check("docs/language.md#limitations" in lim, "limitations link to full list")

# --- French README ---
fr_path = repo / "README.fr.md"
check(fr_path.exists(), "README.fr.md exists")
fr = fr_path.read_text(encoding="utf-8") if fr_path.exists() else ""
heads = lambda t: [len(h) for h in re.findall(r"^(#+) ", re.sub(r"^```.*?^```", "", t, flags=re.M | re.S), re.M)]
check(heads(fr) == heads(text), f"fr: same heading structure ({len(heads(fr))} vs {len(heads(text))})")
fr_blocks = re.findall(r"^```(\w*)\n(.*?)^```", fr, re.M | re.S)
# sh blocks: `#` comments may be translated, so compare with comment text removed (commands must match)
nocom = lambda l, b: (l, re.sub(r"[ \t]*#.*$", "", b, flags=re.M) if l == "sh" else b)
same = lambda bs: [nocom(l, b) for l, b in bs if l != "mermaid"]
check(same(fr_blocks) == same(blocks), "fr: non-Mermaid code blocks identical (sh comments ignored)")
mer = lambda bs: [len(b.splitlines()) for l, b in bs if l == "mermaid"]
check(mer(fr_blocks) == mer(blocks) != [], "fr: Mermaid block present, same shape")
for target in re.findall(r"\]\(([^)\s]+)\)", fr) + re.findall(r'src="([^"]+)"', fr):
    if re.match(r"[a-z]+:|#", target):
        continue
    check((repo / urllib.parse.unquote(target.split("#")[0])).exists(), f"fr: link {target}")
check("docs/assets/htpl.webp" in fr.split("\n## ")[0], "fr: logo at the top")
if credits:
    pos = [fr.find(n) for n in team]
    check(all(p >= 0 for p in pos) and pos == sorted(pos), "fr: team verbatim, alphabetical order")
    check(wrong not in fr, "fr: no misspelled owner name")
top = lambda t: "\n".join(t.splitlines()[:8])
check("](README.fr.md)" in top(text), "en: switch link to README.fr.md at the top")
check("](README.md)" in top(fr), "fr: switch link to README.md at the top")

print(f"{fails} failures")
sys.exit(1 if fails else 0)
