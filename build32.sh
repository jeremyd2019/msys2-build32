#!/bin/bash

cd "$(dirname "$0")"
source 'ci-library.sh'
cd r
mkdir ../artifacts
git_config user.email 'ci@msys2.org'
git_config user.name  'MSYS2 Continuous Integration'
[ ! -e ~/.gnupg/gpg.conf ] && mkdir -p ~/.gnupg && echo -e "keyserver keyserver.ubuntu.com\nkeyserver-options auto-key-retrieve" > ~/.gnupg/gpg.conf
packages=( "$@" )

test -z "${packages}" && success 'No packages - no-op'
define_build_order || failure 'Could not determine build order'

# Build
message 'Building packages' "${packages[@]}"
execute 'Updating system' update_system
execute 'Approving recipe quality' check_recipe_quality
for package in "${packages[@]}"; do
    execute 'Building binary' makepkg --noconfirm --noprogressbar --nocheck --syncdeps --rmdeps --cleanbuild
    execute 'Building source' makepkg --noconfirm --noprogressbar --allsource
    grep -qFx "${package}" ../ci-dont-install-list.txt || execute 'Installing' yes:pacman --noprogressbar --noconfirm --upgrade *.pkg.tar.*
    execute 'Checking dll depencencies' list_dll_deps ./pkg
    mv "${package}"/*.pkg.tar.* ../artifacts
    mv "${package}"/*.src.tar.gz ../artifacts
    unset package
done

# Deploy
cd ../artifacts
# work around github issue with ~ in file name (turns into .)
for a in *~*; do
    mv "$a" "`tr '~' '.' <<<"$a"`"
done
execute 'Generating pacman repository' create_pacman_repository "${PACMAN_REPOSITORY_NAME:-ci-build}"
execute 'SHA-256 checksums' sha256sum *
success 'All artifacts built successfully'
