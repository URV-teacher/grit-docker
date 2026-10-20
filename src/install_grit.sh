#!/usr/bin/env bash
# Installs grit (from the devkitARM r46 release) into /URV/bmde/grit, and its environment (PATH) into
# /etc/profile.d/bmde-grit.sh. Can be run in an Ubuntu / Debian host from a checkout of the repository (after
# scripts/download_assets.sh), and is also used by the BMDE Docker images. Set BMDE_ROOT to install into another
# directory.
set -Eeuo pipefail

BMDE_ROOT="${BMDE_ROOT:-/URV/bmde}"
SUDO=""; if [ "$(id -u)" -ne 0 ]; then SUDO=sudo; fi
GRIT_DIR="${BMDE_ROOT}/grit"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"
DEVKITARM_TARBALL="${SCRIPT_DIR}/../assets/devkitARM_r46-x86_64-linux.tar.bz2"

if [ ! -x "${GRIT_DIR}/grit" ]; then
  ${SUDO} mkdir -p "${GRIT_DIR}"
  if [ -x "${BMDE_ROOT}/devkitPro/devkitARM/bin/grit" ]; then
    # Same binary as the one of the devkitARM already installed
    ${SUDO} cp "${BMDE_ROOT}/devkitPro/devkitARM/bin/grit" "${GRIT_DIR}/grit"
  else
    if [ ! -f "${DEVKITARM_TARBALL}" ]; then
      echo "${DEVKITARM_TARBALL} not found: download it with scripts/download_assets.sh" >&2
      exit 1
    fi
    ${SUDO} apt-get update
    ${SUDO} apt-get install -y --no-install-recommends bzip2
    ${SUDO} tar -xjf "${DEVKITARM_TARBALL}" -C "${GRIT_DIR}" --strip-components=2 devkitARM/bin/grit
  fi
fi

${SUDO} tee /etc/profile.d/bmde-grit.sh > /dev/null <<PROFILE
case ":\${PATH}:" in
  *":${GRIT_DIR}:"*) ;;
  *) export PATH="${GRIT_DIR}:\${PATH}" ;;
esac
PROFILE

echo "grit installed in ${GRIT_DIR}. Open a new session or run: . /etc/profile.d/bmde-grit.sh"
