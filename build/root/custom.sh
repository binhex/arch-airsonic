#!/bin/bash

# exit script if return code != 0
set -e

repo_name="airsonic"
app_name="airsonic"
install_name="airsonic"
install_path="/opt/${install_name}"

# create paths in container
mkdir -p "${install_path}"

# find latest release tag from github
/root/curly.sh -rc 6 -rw 10 -of /tmp/release_tag -url "https://github.com/${repo_name}/${app_name}/releases"
release_tag=$(cat /tmp/release_tag | grep -P -o -m 1 "(?<=/${repo_name}/${app_name}/releases/tag/)[^\"]+")

# download airsonic war file
/root/curly.sh -rc 6 -rw 10 -of "/opt/${install_name}/${install_name}.war" -url "https://github.com/${repo_name}/${app_name}/releases/download/${release_tag}/${app_name}.war"

# download madsonic transcoders (no compiled transcoders available for airsonic yet)
/root/curly.sh -rc 6 -rw 10 -of /tmp/transcode.zip -url "https://github.com/binhex/arch-airsonic/releases/download/20161222/20161222_madsonic-transcode-linux-x64.zip"

# unzip madsonic transcoders
unzip /tmp/transcode.zip -d "${install_path}"

# remove source zip files
rm /tmp/transcode.zip
