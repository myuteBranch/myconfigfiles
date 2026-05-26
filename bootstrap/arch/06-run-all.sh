#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

SCRIPTS=(
  "00-system-setup.sh"
  "01-install-base-and-yay.sh"
  "02-install-gaming.sh"
  "03-install-desktop.sh"
  "04-install-coding.sh"
  "05-link-configs.sh"
)

if [[ "${INSTALL_GAMING:-1}" != "1" ]]; then
  SCRIPTS=(
    "00-system-setup.sh"
    "01-install-base-and-yay.sh"
    "03-install-desktop.sh"
    "04-install-coding.sh"
    "05-link-configs.sh"
  )
fi

for script in "${SCRIPTS[@]}"; do
  echo
  echo "============================================================"
  echo "Running ${script}"
  echo "============================================================"
  "${SCRIPT_DIR}/${script}"
done

echo
echo "All done."
echo "Re-run this anytime after package or dotfile updates."
echo "Tip: use INSTALL_GAMING=0 ./06-run-all.sh to skip gaming packages."
