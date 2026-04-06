#!/usr/bin/env bash
# Semantic web search via Exa API
# Usage: exa-search.sh <query> [num_results]
set -euo pipefail

QUERY="${1:?Usage: exa-search.sh <query> [num_results]}"
NUM="${2:-10}"

if [ -z "${EXA_API_KEY:-}" ]; then
    echo "⚠️  EXA_API_KEY not set."
    echo "Falling back to Jina Search..."
    echo ""
    ENCODED=$(python3 -c "import urllib.parse; print(urllib.parse.quote('$QUERY'))")
    curl -sL "https://s.jina.ai/$ENCODED"
    exit 0
fi

echo "🔍 Exa Search: $QUERY"
echo ""

RESPONSE=$(curl -s -X POST "https://api.exa.ai/search" \
    -H "x-api-key: $EXA_API_KEY" \
    -H "Content-Type: application/json" \
    -d "{
        \"query\": $(python3 -c "import json; print(json.dumps('$QUERY'))"),
        \"numResults\": $NUM,
        \"useAutoprompt\": true,
        \"contents\": {\"text\": {\"maxCharacters\": 500}}
    }" 2>/dev/null)

echo "$RESPONSE" | python3 -c "
import json, sys
try:
    data = json.load(sys.stdin)
    results = data.get('results', [])
    for i, r in enumerate(results, 1):
        print(f\"{i}. {r.get('title', 'No title')}\")
        print(f\"   {r.get('url', '')}\")
        text = r.get('text', '')[:200]
        if text: print(f\"   {text}...\")
        print()
    print(f\"Total: {len(results)} results\")
except Exception as e:
    print(f'Error parsing response: {e}')
    print(sys.stdin.read() if hasattr(sys.stdin, 'read') else '')
"
