#!/usr/bin/env bash
# Installs grit (from the devkitARM r46 release) into /URV/bmde/grit, and its environment (PATH) into
# /etc/profile.d/bmde-grit.sh. Standalone: can be run in an Ubuntu / Debian host, and is also used by the BMDE Docker
# images. Set BMDE_ROOT to install into another directory.
set -Eeuo pipefail

BMDE_ROOT="${BMDE_ROOT:-/URV/bmde}"
SUDO=""; if [ "$(id -u)" -ne 0 ]; then SUDO=sudo; fi
GRIT_DIR="${BMDE_ROOT}/grit"
DEVKITARM_URL="https://wii.leseratte10.de/devkitPro/devkitARM/r46%20%282017%29/devkitARM_r46-x86_64-linux.tar.bz2"
# Pinned, so a changed or tampered download fails instead of being installed
DEVKITARM_SHA256="388b5f5a8f09ccee00073b799ac922aed099b2e0cafcca0d25a5a18b779194ae"

if [ ! -x "${GRIT_DIR}/grit" ]; then
  ${SUDO} mkdir -p "${GRIT_DIR}"
  if [ -x "${BMDE_ROOT}/devkitPro/devkitARM/bin/grit" ]; then
    # Same binary as the one of the devkitARM already installed
    ${SUDO} cp "${BMDE_ROOT}/devkitPro/devkitARM/bin/grit" "${GRIT_DIR}/grit"
  else
    ${SUDO} apt-get update
    ${SUDO} apt-get install -y --no-install-recommends ca-certificates wget bzip2
    wget "${DEVKITARM_URL}" -O /tmp/devkitARM.tar.bz2
    echo "${DEVKITARM_SHA256}  /tmp/devkitARM.tar.bz2" | sha256sum -c --quiet
    ${SUDO} tar -xjf /tmp/devkitARM.tar.bz2 -C "${GRIT_DIR}" --strip-components=2 devkitARM/bin/grit
    rm -f /tmp/devkitARM.tar.bz2
  fi
fi

${SUDO} tee /etc/profile.d/bmde-grit.sh > /dev/null <<PROFILE
case ":\${PATH}:" in
  *":${GRIT_DIR}:"*) ;;
  *) export PATH="${GRIT_DIR}:\${PATH}" ;;
esac
PROFILE

echo "grit installed in ${GRIT_DIR}. Open a new session or run: . /etc/profile.d/bmde-grit.sh"
