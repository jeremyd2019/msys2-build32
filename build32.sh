#!/bin/bash

cd "$(dirname "$0")"
source 'ci-library.sh'
cd r
mkdir ../artifacts
git_config user.email 'ci@msys2.org'
git_config user.name  'MSYS2 Continuous Integration'
packages=( "$@" )

test -z "${packages}" && success 'No packages - no-op'
define_build_order || failure 'Could not determine build order'

# Build
message 'Building packages' "${packages[@]}"
false && execute 'Updating system' update_system
execute 'Approving recipe quality' check_recipe_quality
for package in "${packages[@]}"; do
    execute 'Building binary' makepkg --noconfirm --noprogressbar --skippgpcheck --nocheck --syncdeps --rmdeps --cleanbuild
    execute 'Building source' makepkg --noconfirm --noprogressbar --skippgpcheck --allsource
    grep -qFx "$(<../dont-install-list.txt)" <<< "${package}" || execute 'Installing' yes:pacman --noprogressbar --upgrade *.pkg.tar.*
    execute 'Checking dll depencencies' list_dll_deps ./pkg
    mv "${package}"/*.pkg.tar.* ../artifacts
    mv "${package}"/*.src.tar.gz ../artifacts
    unset package
done

# Deploy
cd ../artifacts
execute 'Generating pacman repository' create_pacman_repository "${PACMAN_REPOSITORY_NAME:-ci-build}"
execute 'SHA-256 checksums' sha256sum *
success 'All artifacts built successfully'
