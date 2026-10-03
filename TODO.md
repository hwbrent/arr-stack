# To-dos

## Arr Stack Rebuild

Build one service at a time. Don't move on until the check passes.

Useful commands:
- Start a service: `docker compose up -d <service>`
- Watch logs: `docker compose logs -f <service>`

### 0. Prep
- [ ] Create a minimal `public.env` (`PUID`, `PGID`, `TZ`)
- [ ] Give Docker Desktop file-sharing access to `/Volumes/Misc` (otherwise bind mounts silently come up empty on macOS)
- [ ] Trim `docker-compose.yml` down to nothing, ready to add services one by one

### 1. Plex (alone)
- [ ] Add only the Plex service, mounting just the media folders
- [ ] Add libraries (Movies, TV Shows)
- [ ] **Check:** something plays locally at `http://<mac-ip>:32400/web`
- Note: Docker Desktop on macOS has no host networking, so local discovery/DLNA are limited. Direct access on port 32400 is enough.

### 2. Gluetun (alone)
- [ ] Add only gluetun and check logs for a successful VPN connection and healthy status
- [ ] Replace `FIREWALL_DROP_LOCAL_LAN` with `FIREWALL_OUTBOUND_SUBNETS` (e.g. `192.168.1.0/24`) so the LAN can reach the UIs
- [ ] **Check:** `docker run --rm --network container:gluetun alpine wget -qO- https://ifconfig.io` shows an Irish VPN IP, not your home IP
- Note: this is where the ExpressVPN config is most likely to break, so get it solid first.

### 3. qBittorrent (behind gluetun)
- [ ] Add qBittorrent with `network_mode: "container:gluetun"`
- [ ] **Check:** UI loads on `:8080` (temporary password is in the logs) and its public IP is the VPN's
- [ ] Set default save path to `/downloads`
- [ ] Test with a legal torrent (e.g. a Linux ISO)
- [ ] **Kill-switch test:** stop gluetun and confirm qBittorrent loses all connectivity

### 4. Radarr, then Sonarr
- [ ] Add Radarr, then Sonarr
- [ ] Add qBittorrent as a download client (host: `gluetun`, port: `8080`)
- [ ] Add root folders (`/movies`, `/tv`)
- [ ] **Check:** the "Test" button passes
- [ ] **Check:** Radarr/Sonarr and qBittorrent both mount `/downloads` so paths line up (mismatches cause "import failed" errors)

### 5. Jackett (or Prowlarr)
- [ ] Add Jackett behind gluetun (consider Prowlarr instead, since it syncs indexers to Radarr/Sonarr automatically)
- [ ] Add one indexer
- [ ] In Radarr/Sonarr, use `http://gluetun:9117/...` as the Torznab URL
- [ ] **Check:** manual search in Radarr, send a result to qBittorrent, watch it download and import

### 6. Seerr (last)
- [ ] Add Seerr
- [ ] Connect to Plex, then Radarr and Sonarr
- [ ] **Check:** request something and confirm it flows all the way through to Plex

### Troubleshooting notes
- Anything sharing gluetun's network is reached via the hostname `gluetun`; other containers use their own container names.
- Second most common problem: mismatched volume paths between the downloader and Radarr/Sonarr.
