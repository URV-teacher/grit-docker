#!/usr/bin/env bash
# Downloads the assets of grit-docker into assets/.
#
# The download logic is the one shared by every component of the BMDE (download_lib.sh, copied from bmde: see it for
# the details). The external resources are listed in the documentation of bmde (docs/development/external-resources.md).
#
#   scripts/download_assets.sh [ASSET...]    (every asset by default)
set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"
# shellcheck source=download_lib.sh
source "${SCRIPT_DIR}/download_lib.sh" "$@"

# grit is taken from it
# devkitARM r46. devkitPro no longer distributes old versions: community mirror
asset devkitARM_r46-x86_64-linux.tar.bz2 388b5f5a8f09ccee00073b799ac922aed099b2e0cafcca0d25a5a18b779194ae \
  "https://wii.leseratte10.de/devkitPro/devkitARM/r46%20%282017%29/devkitARM_r46-x86_64-linux.tar.bz2"

exit "${failed}"
