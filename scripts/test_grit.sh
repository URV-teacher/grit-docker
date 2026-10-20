#!/usr/bin/env bash
# Tests that grit is installed, converting an image into GAS assembly (8 bpp tiles, as in the course).
set -Eeuo pipefail

# CRC-32 of the bytes of a hex string, as used by the PNG chunks
crc32() {
  local hex="$1" crc=0xFFFFFFFF i k
  for ((i = 0; i < ${#hex}; i += 2)); do
    crc=$((crc ^ 16#${hex:i:2}))
    for ((k = 0; k < 8; k++)); do
      if ((crc & 1)); then crc=$(((crc >> 1) ^ 0xEDB88320)); else crc=$((crc >> 1)); fi
    done
  done
  printf '%08x' $((crc ^ 0xFFFFFFFF))
}

# Adler-32 of the bytes of a hex string, as used by the zlib stream
adler32() {
  local hex="$1" a=1 b=0 i
  for ((i = 0; i < ${#hex}; i += 2)); do
    a=$(((a + 16#${hex:i:2}) % 65521))
    b=$(((b + a) % 65521))
  done
  printf '%04x%04x' "${b}" "${a}"
}

# PNG chunk of type $1 (hex) with the data $2 (hex)
png_chunk() {
  printf '%08x%s%s%s' $((${#2} / 2)) "$1" "$2" "$(crc32 "$1$2")"
}

# Writes to $1 a 16x16 PNG with a palette of 4 colors (magenta, the transparent color of the course, black, white and
# red) drawn in a checkered pattern. Its pixels are stored without compression, so no tool is needed to build it.
write_test_png() {
  local size=16 x y pixels="" ihdr plte idat
  for ((y = 0; y < size; y++)); do
    pixels+="00"  # Filter type of the row: none
    for ((x = 0; x < size; x++)); do
      pixels+="$(printf '%02x' $(((x / 4 + y / 4) % 4)))"
    done
  done
  ihdr="$(printf '%08x%08x' "${size}" "${size}")0803000000"  # 8 bits per pixel, indexed color
  plte="ff00ff000000ffffffff0000"
  local length=$((${#pixels} / 2))
  # zlib stream with a single stored (uncompressed) deflate block: LEN and NLEN are little-endian
  idat="7801""01$(printf '%02x%02x' $((length & 0xFF)) $((length >> 8)))"
  idat+="$(printf '%02x%02x' $((~length & 0xFF)) $(((~length >> 8) & 0xFF)))${pixels}$(adler32 "${pixels}")"
  printf '%s' "89504e470d0a1a0a$(png_chunk 49484452 "${ihdr}")$(png_chunk 504c5445 "${plte}")" \
    "$(png_chunk 49444154 "${idat}")$(png_chunk 49454e44 "")" | sed 's/../\\x&/g' | xargs -0 printf > "$1"
}

work_dir="$(mktemp -d)"
write_test_png "${work_dir}/test.png"
(cd "${work_dir}" && grit test.png -gB8 -gTFF00FF -o test)
grep -q "testTiles" "${work_dir}/test.s"
rm -rf "${work_dir}"
echo "grit OK"
