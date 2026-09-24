#!/usr/bin/env bash
# Auto-format edited files. Requires jq. Never fails the tool call.
f=$(jq -r '.tool_input.file_path // empty' 2>/dev/null)
case "$f" in
  *.go) command -v gofmt >/dev/null && gofmt -w "$f" ;;
  *.dart) command -v dart >/dev/null && dart format "$f" >/dev/null 2>&1 ;;
  *.tf) command -v terraform >/dev/null && terraform fmt "$f" >/dev/null 2>&1 ;;
esac
exit 0
