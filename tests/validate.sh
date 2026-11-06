#!/usr/bin/env bash
# Structural checks for the plugin. No network, no dependencies beyond bash + python3/jq.
set -uo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."

fail=0
ok()  { printf '  ok   %s\n' "$1"; }
bad() { printf '  FAIL %s\n' "$1"; fail=1; }

json_valid() {
  if command -v jq > /dev/null 2>&1; then jq -e . "$1" > /dev/null 2>&1
  else python3 -m json.tool "$1" > /dev/null 2>&1; fi
}

echo "JSON manifests"
for f in .claude-plugin/plugin.json .claude-plugin/marketplace.json hooks/hooks.json; do
  if json_valid "$f"; then ok "$f parses"; else bad "$f is not valid JSON"; fi
done

echo "Skills"
count=0
for dir in skills/*/; do
  name=$(basename "$dir")
  file="$dir/SKILL.md"
  count=$((count + 1))
  if [ ! -f "$file" ]; then bad "$name: missing SKILL.md"; continue; fi

  first=$(sed -n '1p' "$file")
  [ "$first" = "---" ] && ok "$name: frontmatter opens" || bad "$name: no frontmatter"

  fm_name=$(awk '/^---/{n++; next} n==1 && /^name:/{sub(/^name:[ ]*/,""); print; exit}' "$file")
  fm_desc=$(awk '/^---/{n++; next} n==1 && /^description:/{sub(/^description:[ ]*/,""); print; exit}' "$file")

  [ "$fm_name" = "$name" ] && ok "$name: name matches folder" || bad "$name: name '$fm_name' != folder"
  echo "$name" | grep -Eq '^[a-z0-9]+(-[a-z0-9]+)*$' && ok "$name: kebab-case" || bad "$name: not kebab-case"
  [ -n "$fm_desc" ] && ok "$name: has description" || bad "$name: empty description"
  [ "${#fm_desc}" -le 1024 ] && ok "$name: description <= 1024 chars (${#fm_desc})" || bad "$name: description too long"
  lines=$(wc -l < "$file")
  [ "$lines" -le 500 ] && ok "$name: $lines lines (<= 500)" || bad "$name: $lines lines (> 500)"
done
[ "$count" -ge 5 ] && ok "$count skills present" || bad "expected at least 5 skills, found $count"

echo "Bootstrap routing"
for dir in skills/*/; do
  name=$(basename "$dir")
  [ "$name" = "using-engineering-harness" ] && continue
  grep -q "\`$name\`" skills/using-engineering-harness/SKILL.md \
    && ok "bootstrap mentions $name" || bad "bootstrap does not mention $name"
done

echo "Hook"
[ -r hooks/session-start ] && ok "hooks/session-start exists" || bad "hooks/session-start missing"
grep -q 'bash \\"${CLAUDE_PLUGIN_ROOT}/hooks/session-start' hooks/hooks.json \
  && ok "hooks.json runs the script through bash (no exec bit needed)" || bad "hooks.json must call the script via bash"
out=$(CLAUDE_PLUGIN_ROOT="$PWD" bash hooks/session-start 2> /dev/null) || true
echo "$out" | grep -q "engineering-harness" && ok "hook emits harness context" || bad "hook output missing context"
if command -v jq > /dev/null 2>&1; then
  echo "$out" | jq -e '.hookSpecificOutput.additionalContext | length > 100' > /dev/null 2>&1 \
    && ok "hook emits valid JSON with context" || bad "hook JSON invalid"
fi
echo "$out" | grep -q "^name:" && bad "hook leaked frontmatter" || ok "frontmatter stripped"

echo "Cross-references"
for ref in $(grep -rhoE 'references/[a-z0-9._-]+' skills --include=SKILL.md | sort -u); do
  found=$(find skills -path "*/$ref" | head -n1)
  [ -n "$found" ] && ok "$ref exists" || bad "$ref referenced but missing"
done

echo
if [ "$fail" -eq 0 ]; then echo "All checks passed."; else echo "Some checks FAILED."; fi
exit "$fail"
