#!/usr/bin/env bash
set -ex

rm -rf freetype/ harfbuzz/ brotli/
git clone --depth 1 --branch VER-2-12-1 https://github.com/freetype/freetype
git clone --depth 1 --branch 4.3.0 https://github.com/harfbuzz/harfbuzz
git clone --depth 1 --branch v1.0.9 https://github.com/google/brotli

# --- FreeType ---
pushd freetype/
rm -rf .git/ .clang-format .gitlab-ci.yml .mailmap .gitignore .gitmodules
rm autogen.sh CMakeLists.txt configure Makefile meson.build meson_options.txt \
    modules.cfg README README.git vms_make.com src/tools/*.c
rm -r devel/ docs/ objs/ subprojects/ tests/
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
rm -rf .git/ .ci/ .circleci/ .github/ .clang-format .codecov.yml .editorconfig
rm AUTHORS NEWS README THANKS configure.ac Makefile.am meson.build \
    replace-enum-strings.cmake harfbuzz.doap BUILD.md CONFIG.md README.md \
    README.mingw.md README.python.md RELEASING.md TESTING.md git.mk autogen.sh \
    mingw-configure.sh CMakeLists.txt meson_options.txt
rm -r docs/ m4/ perf/ subprojects/ test/ util/ src/ms-use
find ./src -type f \
    ! -iname '*.cc' -a \
    ! -iname '*.hh' -a \
    ! -iname '*.h' \
    -exec rm -f {} +
popd


# --- Brotli ---
pushd brotli/
find -mindepth 1 -maxdepth 1 \
    ! -iname 'c' -a \
    ! -iname 'LICENSE' \
    -exec rm -rf {} +
mv c/* ./
rm -rf c fuzz tools
popd