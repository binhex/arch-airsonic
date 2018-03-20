#!/bin/bash

# exit script if return code != 0
set -e

# build scripts
####

# download build scripts from github
curl --connect-timeout 5 --max-time 600 --retry 5 --retry-delay 0 --retry-max-time 60 -o /tmp/scripts-master.zip -L https://github.com/binhex/scripts/archive/master.zip

# unzip build scripts
unzip /tmp/scripts-master.zip -d /tmp

# move shell scripts to /root
mv /tmp/scripts-master/shell/arch/docker/*.sh /root/

# pacman packages
####

# define pacman packages
pacman_packages="libcups fontconfig libx264 libvpx"

# install compiled packages using pacman
if [[ ! -z "${pacman_packages}" ]]; then
	pacman -S --needed $pacman_packages --noconfirm
fi

# aor packages
####

# define arch official repo (aor) packages
aor_packages=""

# call aor script (arch official repo)
source /root/aor.sh

# aur packages
####

# define aur packages
aur_packages="jre8 ffmpeg-headless"

# call aur install script (arch user repo)
source /root/aur.sh

# github releases
####

# download airsonic
/root/github.sh -df airsonic.war -dp "/tmp" -ep "/tmp/extracted" -ip "/opt/airsonic" -go "airsonic" -gr "airsonic" -rt "binary"

# container perms
####

# define comma separated list of paths 
install_paths="/opt/airsonic,/home/nobody"

# split comma separated string into list for install paths
IFS=',' read -ra install_paths_list <<< "${install_paths}"

# process install paths in the list
for i in "${install_paths_list[@]}"; do

	# confirm path(s) exist, if not then exit
	if [[ ! -d "${i}" ]]; then
		echo "[crit] Path '${i}' does not exist, exiting build process..." ; exit 1
	fi

done

# convert comma separated string of install paths to space separated, required for chmod/chown processing
install_paths=$(echo "${install_paths}" | tr ',' ' ')

# create file with contents of here doc, note EOF is NOT quoted to allow us to expand current variable 'install_paths'
# we use escaping to prevent variable expansion for PUID and PGID, as we want these expanded at runtime of init.sh
# note - do NOT double quote variable for install_paths otherwise this will wrap space separated paths as a single string
cat <<EOF > /tmp/permissions_heredoc
# set permissions inside container
chown -R "\${PUID}":"\${PGID}" ${install_paths}
chmod -R 775 ${install_paths}

EOF

# replace permissions placeholder string with contents of file (here doc)
sed -i '/# PERMISSIONS_PLACEHOLDER/{
    s/# PERMISSIONS_PLACEHOLDER//g
    r /tmp/permissions_heredoc
}' /root/init.sh
rm /tmp/permissions_heredoc

# env vars
####

cat <<'EOF' > /tmp/envvars_heredoc
export CONTEXT_PATH=$(echo "${CONTEXT_PATH}" | sed -e 's~^[ \t]*~~;s~[ \t]*$~~')
if [[ ! -z "${CONTEXT_PATH}" ]]; then
	echo "[info] CONTEXT_PATH defined as '${CONTEXT_PATH}'" | ts '%Y-%m-%d %H:%M:%.S'
else
	echo "[warn] CONTEXT_PATH not defined (via -e CONTEXT_PATH), assuming site runs from '/'" | ts '%Y-%m-%d %H:%M:%.S'
fi

EOF

# replace envvar placeholder string with contents of file (here doc)
sed -i '/# ENVVARS_PLACEHOLDER/{
    s/# ENVVARS_PLACEHOLDER//g
    r /tmp/envvars_heredoc
}' /root/init.sh
rm /tmp/envvars_heredoc

# cleanup
yes|pacman -Scc
rm -rf /usr/share/locale/*
rm -rf /usr/share/man/*
rm -rf /usr/share/gtk-doc/*
rm -rf /tmp/*
