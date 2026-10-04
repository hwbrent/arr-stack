# To-dos

## Arr Stack Rebuild

Build one service at a time. Don't move on until the check passes.

Scope: personal use on my own network only. No remote access / port forwarding for now.

Useful commands:
- Start a service: `docker compose up -d <service>`
- Watch logs: `docker compose logs -f <service>`

### 0. Prep
- [x] Create a minimal `public.env` (`PUID`, `PGID`, `TZ`)
- [x] Make sure OrbStack can read `/Volumes/Misc` (macOS may prompt for removable-volume access; if not, grant it in System Settings > Privacy & Security > Files and Folders / Full Disk Access). Check with `docker run --rm -v /Volumes/Misc/Plex:/test alpine ls /test`, which should list your media folders, not come up empty.
    - "I think it has access? In Settings in 'Files and Folders' it has 'Documents Folder' and 'Removable Volumes' checked"
- [x] Trim `docker-compose.yml` down to nothing, ready to add services one by one

### 1. Plex (alone)
- [x] Add only the Plex service, mounting just the media folders
- [x] Add libraries (Movies, TV Shows)
- [x] **Check:** something plays locally at `http://localhost:32400/web` on the Mac
    - `http://192.0.0.1:32400` fails because that isn't the Mac's address, so this is expected
- [x] In Plex Settings > Remote Access, make sure remote access is **disabled** (local-only for now)
- [x] **Check:** plays from another device on the home network (phone/TV) at `http://<mac-lan-ip>:32400/web`
- Note: macOS containers still sit behind a VM, so Plex's local discovery/DLNA may not work. Direct access on port 32400 is enough. (OrbStack also gives containers local domains like `plex.orb.local`, handy for testing from the Mac, but other devices on your LAN need the Mac's IP and the published port.)

### 2. Gluetun (alone)
- [x] Add only gluetun and check logs for a successful VPN connection and healthy status
- [ ] Replace `FIREWALL_DROP_LOCAL_LAN` with `FIREWALL_OUTBOUND_SUBNETS` (e.g. `192.168.1.0/24`) so the LAN can reach the UIs
- [x] **Check:** `docker run --rm --network container:gluetun alpine wget -qO- https://ifconfig.io` shows an Irish VPN IP, not your home IP
- Note: this is where the ExpressVPN config is most likely to break, so get it solid first.

### 3. qBittorrent (behind gluetun)
- [x] Add qBittorrent with `network_mode: "container:gluetun"`
- [x] **Check:** UI loads on `:8080` (temporary password is in the logs) and its public IP is the VPN's
- [x] Set default save path to `/downloads`
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
- [ ] **Check:** manual search in Radarr, send a result to qBittorrent, watch it download and import in Plex

### 6. Seerr (optional)
Only worth it if other people will make requests. For just me, Radarr/Sonarr directly are enough.
- [ ] Add Seerr
- [ ] Connect to Plex, then Radarr and Sonarr
- [ ] **Check:** request something and confirm it flows all the way through to Plex

### Later / maybe
- [ ] Remote access to Plex for others (port forwarding or a VPN like Tailscale)
### Later / maybe
- [ ] Reach Plex away from home via Tailscale (no Remote Access needed): add `100.64.0.0/10` to Plex's LAN Networks and the Tailscale address to Custom server access URLs
- [ ] If gluetun-routed UIs don't load over Tailscale, add `100.64.0.0/10` to `FIREWALL_OUTBOUND_SUBNETS`

### Troubleshooting notes
- Anything sharing gluetun's network is reached via the hostname `gluetun`; other containers use their own container names.
- Second most common problem: mismatched volume paths between the downloader and Radarr/Sonarr.
- OrbStack: `orb.local` domains and container IPs work from the Mac only, not from other devices. Use `<mac-ip>:<port>` from phones, TVs and other machines.
