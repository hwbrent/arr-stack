# arr-stack

## What's in the stack

| Name | Summary of what it does | Link |
| - | - | - |
| Plex Media Server | Organizes video, music and photos from personal media libraries and streams them to smart TVs, streaming boxes and mobile devices | https://docs.linuxserver.io/images/docker-plex/ |
| Jackett | Works as a proxy server: it translates queries from apps (Sonarr, SickRage, CouchPotato, Mylar, etc) into tracker-site-specific http queries, parses the html response, then sends results back to the requesting software. This allows for getting recent uploads (like RSS) and performing searches. Jackett is a single repository of maintained indexer scraping & translation logic - removing the burden from other apps | https://docs.linuxserver.io/images/docker-jackett/ |
| Sonarr | A PVR for usenet and bittorrent users. It can monitor multiple RSS feeds for new episodes of your favorite shows and will grab, sort and rename them. It can also be configured to automatically upgrade the quality of files already downloaded when a better quality format becomes available | https://docs.linuxserver.io/images/docker-sonarr |
| Radarr | A fork of Sonarr to work with movies à la Couchpotato | https://docs.linuxserver.io/images/docker-radarr |
| Overseerr | A free and open source software application for managing requests for your media library. It integrates with your existing services, such as Sonarr, Radarr, and Plex | https://hub.docker.com/r/sctx/overseerr |
<!-- | Seerr | Seerr is a free and open source software application for managing requests for your media library. It integrates with the media server of your choice: Jellyfin, Plex, and Emby. In addition, it integrates with your existing services, such as Sonarr, Radarr. The successor of Overseer+Jellyseer | https://docs.seerr.dev/getting-started/docker/?docker-methods=docker-compose | -->
| Gluetun | Lightweight Swiss-knife VPN client to connect to several VPN providers | https://hub.docker.com/r/qmcgaw/gluetun |

## Also used

| Name | Summary of what it does | Link |
| - | - | - |
| Orbstack | a fast, light, and simple way to run containers and Linux machines. It's a supercharged alternative to Docker Desktop and WSL, all in one easy-to-use app | https://docs.orbstack.dev/ |
| qBittorrent | Cross-platform free and open-source BitTorrent client | https://www.qbittorrent.org/ |
