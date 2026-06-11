# Google TV / Android TV — WireGuard client setup

## Prerequisites

- VPN server deployed and running
- QR code (`client.qr`) retrieved from server

## Steps

1. On your Google TV, go to the **Play Store** and search for **WireGuard**.

2. Install the WireGuard app (by WireGuard LLC).

3. Transfer the client QR code to a second device (phone or tablet) that has a
   screen — you'll scan it with the TV's camera.

   To retrieve the QR code from the server:

   ```bash
   scp ubuntu@<server-ip>:/opt/wireguard/clients/client.qr ./client.png
   ```

4. Open WireGuard on Google TV.

5. Tap **+** → **Scan from QR code**.

6. Point the TV's camera at the QR code displayed on your other device.

   > If your TV remote has a QR button, you can also upload the QR image
   > directly.

7. Tap **Save**, then toggle the connection on.

## Alternative: side-loading the config file

If QR scanning doesn't work:

1. Save `client.conf` to a USB drive (FAT32).
2. Plug the USB drive into the TV.
3. Use a file manager app (e.g. X-plore) to copy the file to
   `Internal storage/Download/`.
4. In WireGuard, tap **+** → **Import from file or archive** and select the
   config.

## Troubleshooting

- **QR code too small / blurry** → generate a larger QR with:
  ```bash
  qrencode -t png -s 10 -o client.png < client.conf
  ```
  Then transfer the PNG to your phone and display it on a tablet/laptop screen.

- **TV has no camera** → use the USB/import method instead.

- **Connection drops** → the config includes `PersistentKeepalive = 25`. If
  your network is aggressively NAT-ing, try 15 instead.

- **Can't find WireGuard on Play Store** → Google TV might be hiding phone
  apps. Search from the web Play Store and push to your TV, or side-load the
  APK.