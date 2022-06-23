#!/usr/bin/env bash
set -e -x

rm -rf freetype/ harfbuzz/ brotli/
git clone --depth 1 --branch VER-2-12-1 https://github.com/freetype/freetype
git clone --depth 1 --branch 4.3.0 https://github.com/harfbuzz/harfbuzz
git clone --depth 1 --branch v1.0.9 https://github.com/google/brotli

# --- FreeType ---
pushd freetype/
ft_delete=($(find -maxdepth 1 | grep -v -E '^./(builds|include|src|LICENSE\.TXT)$'))
rm -rf "${ft_delete[@]}" || true
rm src/tools/*.c
find ./src -type f \
    ! -iname '*.c' -a \
    ! -iname '*.h' \
    -exec rm -f {} +
mv builds/ tmp/
mkdir -p builds/unix
mkdir builds/windows
pushd ./tmp
mv unix/ftsystem.c ../builds/unix/
mv windows/ftsystem.c windows/ftdebug.c ../builds/windows
popd
rm -r tmp
popd

# --- HarfBuzz ---
pushd harfbuzz/
hb_delete=$( (
    find | grep -v -E '^./(src(\/OT.*)?|COPYING)$' | grep -v -E '.*\.(cc|h|hh)$'
    find | grep -E '.*\.(cc|h|hh)$' | grep -E 'test|main.cc'
) | cat)
for f in ${hb_delete[@]}; do
    rm -rf "${f}" || true
done
popd

# --- Brotli ---
pushd brotli/
brotli_delete=($(find -maxdepth 1 | grep -v -E '^./(c|LICENSE)$'))
rm -rf "${brotli_delete[@]}" || true
mv c/* ./
rm -rf c fuzz tools
popd
