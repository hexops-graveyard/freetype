#!/usr/bin/env bash
set -ex

rm -rf freetype/
git clone --depth 1 --branch VER-2-12-1 https://github.com/freetype/freetype
cd freetype/

# Remove non-C files
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
