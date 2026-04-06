# ---

> OpenClaw AI Agent Skill

---
name: exa-search
description: Semantic web search via Exa API (exa.ai). Returns high-quality, AI-optimized search results with optional full-page content. Use when you need semantic search (meaning-based, not keyword), finding similar pages to a URL, or research-grade web search. Requires EXA_API_KEY. Free tier available at exa.ai.
---

# Exa Search

Semantic web search powered by Exa (formerly Metaphor). Goes beyond keyword matching to find results by meaning.

## Setup

1. Get a free API key at https://exa.ai
2. Set it: `export EXA_API_KEY="your-key-here"`
   Or add to `~/.bashrc` / `~/.openclaw/workspace/.env`

## Quick Start

```bash
scripts/exa-search.sh "best practices for SaaS pricing in Southeast Asia"
```

## API Commands

### Basic search
```bash
curl -s -X POST "https://api.exa.ai/search" \
  -H "x-api-key: $EXA_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "query": "AI accounting software Indonesia",
    "numResults": 10,
    "useAutoprompt": true
  }'
```

### Search with full content
```bash
curl -s -X POST "https://api.exa.ai/search" \
  -H "x-api-key: $EXA_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "query": "OCR invoice processing",
    "numResults": 5,
    "contents": {"text": {"maxCharacters": 2000}}
  }'
```

### Find similar pages
```bash
curl -s -X POST "https://api.exa.ai/findSimilar" \
  -H "x-api-key: $EXA_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "url": "https://example.com/article",
    "numResults": 10
  }'
```

### Filter by domain/date
```bash
# Only results from specific domains
"includeDomains": ["arxiv.org", "github.com"]

# Date range
"startPublishedDate": "2025-01-01T00:00:00.000Z"
```

## Search Types

- `"type": "auto"` — let Exa decide (default)
- `"type": "keyword"` — traditional keyword search
- `"type": "neural"` — pure semantic search

## Fallback

If no API key is set, use Jina Search as fallback:
```bash
curl -s "https://s.jina.ai/your+query"
```

Or use the Tavily search wrapper at `~/bin/search`.

## Installation

```bash
cp -r exa-search/ ~/.openclaw/workspace/skills/exa-search/
```

## License

MIT © [Sentra Technology](https://github.com/Icattj)
