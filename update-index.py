import json, re, sys
from pathlib import Path

date = sys.argv[1]
content = Path(sys.argv[2]).read_text(encoding="utf-8").strip()

html_path = Path(__file__).parent / "index.html"
html = html_path.read_text(encoding="utf-8")

pattern = r'(<script type="application/json" id="reports-data">\s*)(\[.*?\])(\s*</script>)'
match = re.search(pattern, html, re.DOTALL)
if not match:
    print("ERROR: reports-data block not found in index.html")
    sys.exit(1)

existing = json.loads(match.group(2))
existing.insert(0, {"date": date, "content": content})
updated_json = json.dumps(existing, ensure_ascii=False, indent=2)
new_html = html[:match.start(2)] + updated_json + html[match.end(2):]
html_path.write_text(new_html, encoding="utf-8")
print(f"OK: index.html updated — {len(existing)} reports total")
