#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<EOF
Usage: $(basename "$0") [-t TEMPLATE] [-y] TARGET [TARGET ...]
  -t TEMPLATE   Path to template file (default: main_template.py next to this script's real path)
  -y            Overwrite without prompting
  -h            Show this help

Notes:
- If TARGET is a directory, the file name of the template is used inside it.
- Directories are created as needed.
- When invoked via a symlink, the template is resolved relative to the real script path.
EOF
}

# --- helpers ---
resolve_realpath() {
  # Resolve to an absolute, symlink-free path
  # Prefer realpath, fallback to readlink -f
  if command -v realpath >/dev/null 2>&1; then
    realpath "$1"
  elif command -v readlink >/dev/null 2>&1; then
    readlink -f "$1"
  else
    # Minimal fallback: cd to dirname and print physical pwd + basename
    # (won't resolve nested symlinks fully if readlink/realpath are missing)
    local d b
    d="$(cd -- "$(dirname -- "$1")" && pwd -P)"
    b="$(basename -- "$1")"
    printf '%s/%s\n' "$d" "$b"
  fi
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

if [[ $# -lt 1 ]]; then
  usage; exit 1
fi

# --- script real path (follow symlinks) ---
SCRIPT_PATH="$(resolve_realpath "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(dirname -- "$SCRIPT_PATH")"

# --- template resolution ---
if [[ -z "${TEMPLATE}" ]]; then
  TEMPLATE="${SCRIPT_DIR}/main_template.py"
else
  # If user provided a relative -t, interpret it relative to the *real* script dir
  if [[ "$TEMPLATE" != /* ]]; then
    TEMPLATE="${SCRIPT_DIR}/$TEMPLATE"
  fi
fi

# Try to canonicalize TEMPLATE if it exists
if [[ -e "$TEMPLATE" ]]; then
  TEMPLATE="$(resolve_realpath "$TEMPLATE")"
fi

if [[ ! -f "$TEMPLATE" ]]; then
  echo "Template not found: $TEMPLATE" >&2
  exit 1
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
