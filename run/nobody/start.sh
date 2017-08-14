#!/bin/bash

volume_transcode_path="/config/transcode"
volume_podcast_path="/config/media/podcast"
volume_playlists_path="/config/playlists"

# create paths on /config
mkdir -p "${volume_transcode_path}"
mkdir -p "${volume_podcast_path}"
mkdir -p "${volume_playlists_path}"

container_libresonic_path="/opt/airsonic"
container_transcode_path="${container_airsonic_path}/transcode"

# copy transcode to config directory if path is empty
if [ ! "$(ls -A ${volume_transcode_path})" ]; then

	echo "[info] transcode directory ${volume_transcode_path} is empty, copying transcoder binaries..."
	cp "${container_transcode_path}/"* "${volume_transcode_path}/"

else

	echo "[info] transcoder binaries already in ${volume_transcode_path}..."

fi

# define java settings passed to airsonic
airsonic_HOST="0.0.0.0"
airsonic_PORT="4040"
airsonic_HTTPS_PORT="4050"
airsonic_CONTEXT_PATH="${CONTEXT_PATH}"
airsonic_HOME="/config"
airsonic_MIN_MEMORY="256"
airsonic_MAX_MEMORY="2046"
airsonic_PIDFILE=""
airsonic_DEFAULT_MUSIC_FOLDER="/media"
airsonic_DEFAULT_PODCAST_FOLDER="/config/media/podcast"
airsonic_DEFAULT_PLAYLIST_FOLDER="/config/playlists"
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
  -Djava.awt.headless=true \
  -jar "${airsonic_WAR_PATH}"
