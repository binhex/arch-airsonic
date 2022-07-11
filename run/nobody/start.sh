#!/usr/bin/dumb-init /bin/bash

# define root path on /config
root_folder="/config"
mkdir -p "${root_folder}"

config_transcode_path="${root_folder}/transcode"
config_podcast_path="${root_folder}/media/podcast"
config_playlists_path="${root_folder}/playlists"

# create paths on /config
mkdir -p "${config_transcode_path}"
mkdir -p "${config_podcast_path}"
mkdir -p "${config_playlists_path}"

# remove previous lock file (if it exists)
rm -f "${root_folder}/db/airsonic.lck"

# symlink ffmpeg (not statically compiled) to /config/airsonic/transcode/
# This path is constructed from "${airsonic_HOME}/transcode/" and cannot be altered at this time.
ln -s /usr/bin/ffmpeg "${config_transcode_path}/ffmpeg"

# define java settings passed to airsonic
airsonic_HOST="0.0.0.0"
airsonic_PORT="4040"
airsonic_HTTPS_PORT="4050"
airsonic_CONTEXT_PATH="${CONTEXT_PATH}"
airsonic_HOME="${root_folder}"
airsonic_MIN_MEMORY="256"
airsonic_MAX_MEMORY="${MAX_MEMORY}"
airsonic_PIDFILE=""
airsonic_DEFAULT_MUSIC_FOLDER="/media"
airsonic_DEFAULT_PODCAST_FOLDER="${config_podcast_path}"
airsonic_DEFAULT_PLAYLIST_FOLDER="${config_playlists_path}"
airsonic_WAR_PATH="/opt/airsonic/airsonic.war"

# run java pointing at airsonic war file with defined settings
java -Xms"${airsonic_MIN_MEMORY}"m -Xmx"${airsonic_MAX_MEMORY}"m\
  -Dserver.host="${airsonic_HOST}" \
  -Dserver.port="${airsonic_PORT}" \
  -Dserver.contextPath="${airsonic_CONTEXT_PATH}" \
  -Dairsonic.home="${airsonic_HOME}" \
  -Dairsonic.host="${airsonic_HOST}" \
  -Dairsonic.port="${airsonic_PORT}" \
  -Dairsonic.httpsPort="${airsonic_HTTPS_PORT}" \
  -Dairsonic.contextPath="${airsonic_CONTEXT_PATH}" \
  -Dairsonic.defaultMusicFolder="${airsonic_DEFAULT_MUSIC_FOLDER}" \
  -Dairsonic.defaultPodcastFolder="${airsonic_DEFAULT_PODCAST_FOLDER}" \
  -Dairsonic.defaultPlaylistFolder="${airsonic_DEFAULT_PLAYLIST_FOLDER}" \
  -Dserver.use-forward-headers=true \
  -Djava.awt.headless=true \
  -jar "${airsonic_WAR_PATH}"
