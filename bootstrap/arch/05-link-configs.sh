#!/usr/bin/env bash
set -euo pipefail

if [[ "${EUID}" -eq 0 ]]; then
  echo "Run this as your normal user, not root."
  exit 1
fi

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd -- "${SCRIPT_DIR}/../.." && pwd)"
DOTFILES_DIR="${REPO_ROOT}/dotfiles"
TIMESTAMP="$(date +%Y%m%d%H%M%S)"

if [[ ! -d "${DOTFILES_DIR}" ]]; then
  echo "Could not find dotfiles directory at: ${DOTFILES_DIR}"
  exit 1
fi

link_path() {
  local source="$1"
  local target="$2"

  if [[ ! -e "${source}" ]]; then
    echo "Missing source: ${source}"
    exit 1
  fi

  mkdir -p "$(dirname "${target}")"

  local desired current
  desired="$(readlink -f "${source}")"

  if [[ -L "${target}" ]]; then
    current="$(readlink -f "${target}" 2>/dev/null || true)"
    if [[ "${current}" == "${desired}" ]]; then
      echo "ok    ${target}"
      return
    fi
    rm -f "${target}"
  elif [[ -e "${target}" ]]; then
    mv "${target}" "${target}.bak.${TIMESTAMP}"
    echo "backup ${target} -> ${target}.bak.${TIMESTAMP}"
  fi

  ln -s "${source}" "${target}"
  echo "link  ${target} -> ${source}"
}

echo "==> Linking config files from ${DOTFILES_DIR}"

link_path "${DOTFILES_DIR}/fish"              "${HOME}/.config/fish"
link_path "${DOTFILES_DIR}/lazynvim"          "${HOME}/.config/nvim"
link_path "${DOTFILES_DIR}/jj"                "${HOME}/.config/jj"
link_path "${DOTFILES_DIR}/zed"               "${HOME}/.config/zed"
link_path "${DOTFILES_DIR}/alacritty.toml"    "${HOME}/.config/alacritty/alacritty.toml"
link_path "${DOTFILES_DIR}/starship.toml"     "${HOME}/.config/starship.toml"
link_path "${DOTFILES_DIR}/.tmux.conf"        "${HOME}/.tmux.conf"

echo "==> Config linking complete"
echo "Note: existing real files were backed up as *.bak.${TIMESTAMP}"
