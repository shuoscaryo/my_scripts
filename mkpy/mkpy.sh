#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<EOF
Usage: $(basename "$0") [-t TEMPLATE] [-y] TARGET [TARGET ...]
  -t TEMPLATE   Path to template file (default: main_template.py next to this script)
  -y            Overwrite without prompting
  -h            Show this help

Notes:
- If TARGET is a directory, the file name of the template is used inside it.
- Directories are created as needed.
EOF
}

confirm_overwrite() {
  local path="$1"
  while true; do
    read -r -p "File '$path' exists. Overwrite? [y/n] " ans || true
    case "$ans" in
      y|Y) return 0 ;;
      n|N) return 1 ;;
      *) ;;
    esac
  done
}

# --- options ---
OVERWRITE="ask"
TEMPLATE=""
while getopts ":t:yh" opt; do
  case "$opt" in
    t) TEMPLATE="$OPTARG" ;;
    y) OVERWRITE="yes" ;;
    h) usage; exit 0 ;;
    \?) echo "Invalid option: -$OPTARG" >&2; usage; exit 1 ;;
  esac
done
shift $((OPTIND-1))

# --- template resolution ---
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
: "${TEMPLATE:="${SCRIPT_DIR}/main_template.py"}"

if [[ ! -f "$TEMPLATE" ]]; then
  echo "Template not found: $TEMPLATE" >&2
  exit 1
fi

if [[ $# -lt 1 ]]; then
  usage; exit 1
fi

# --- copy loop ---
tpl_base="$(basename "$TEMPLATE")"
for target in "$@"; do
  if [[ -d "$target" || "${target: -1}" == "/" ]]; then
    # Treat as directory
    mkdir -p "$target"
    dest="${target%/}/$tpl_base"
  else
    # Treat as file path
    mkdir -p "$(dirname "$target")"
    dest="$target"
  fi

  if [[ -e "$dest" ]]; then
    case "$OVERWRITE" in
      yes) : ;;
      ask) confirm_overwrite "$dest" || { echo "Skipped $dest"; continue; } ;;
    esac
  fi

  cp -f "$TEMPLATE" "$dest"
  echo "Created: $dest"
done
