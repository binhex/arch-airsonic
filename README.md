**Application**

[Airsonic](https://github.com/airsonic/airsonic)

**Description**

Airsonic is a free, web-based media streamer, providing ubiquitious access to your music. Use it to share your music with friends, or to listen to your own music while at work. You can stream to multiple players simultaneously, for instance to one player in your kitchen and another in your living room.

Airsonic is designed to handle very large music collections (hundreds of gigabytes). Although optimized for MP3 streaming, it works for any audio or video format that can stream over HTTP, for instance AAC and OGG. By using transcoder plug-ins, Airsonic supports on-the-fly conversion and streaming of virtually any audio format, including WMA, FLAC, APE, Musepack, WavPck and Shorten.

If you have constrained bandwidth, you may set an upper limit for the bitrate of the music streams. Airsonic will then automatically resample the music to a suitable bitrate.

In addition to being a streaming media server, Airsonic works very well as a local jukebox. The intuitive web interface, as well as search and index facilities, are optimized for efficient browsing through large media libraries. Airsonic also comes with an integrated Podcast receiver, with many of the same features as you find in iTunes.

Based on Java technology, Airsonic runs on most platforms, including Windows, Mac, Linux and Unix variants.

**Build notes**

Latest stable release of airsonic.

**Usage**
```
docker run -d \
    -p 4040:4040 \
    --name=<container name> \
    -v <path for media files>:/media \
    -v <path for config files>:/config \
    -v /etc/localtime:/etc/localtime:ro \
    -e CONTEXT_PATH=<root path> \
    -e MAX_MEMORY=<max memory for java> \
    -e UMASK=<umask for created files> \
    -e PUID=<uid for user> \
    -e PGID=<gid for user> \
    binhex/arch-airsonic
```

Please replace all user variables in the above command defined by <> with the correct values.

**Access application**

`http://<host ip>:4040`

username/password is admin/admin

**Example**
```
docker run -d \
    -p 4040:4040 \
    --name=airsonic \
    -v /media/music/:/media \
    -v /apps/docker/airsonic:/config \
    -v /etc/localtime:/etc/localtime:ro \
    -e CONTEXT_PATH=\ \
    -e MAX_MEMORY=2046 \
    -e UMASK=000 \
    -e PUID=0 \
    -e PGID=0 \
    binhex/arch-airsonic
```

**Notes**

User ID (PUID) and Group ID (PGID) can be found by issuing the following command for the user you want to run the container as:-

```
id <username>
```
___
If you appreciate my work, then please consider buying me a beer  :D

[![PayPal donation](https://www.paypal.com/en_US/i/btn/btn_donate_SM.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=MM5E27UX6AUU4)

[Documentation](https://github.com/binhex/documentation) | [Documentation](https://github.com/binhex/documentation) | [Support forum](https://forums.lime-technology.com/topic/59427-support-binhex-airsonic/)