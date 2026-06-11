# OPNsense — WireGuard client setup

## Prerequisites

- VPN server deployed and running
- Client config file (`client.conf`) retrieved from server
- The LAN IP of the machine you want to route through the VPN
  (e.g. `192.168.1.100`)

## Steps

### 1. Install the WireGuard plugin

- Navigate to **System** → **Firmware** → **Plugins**.
- Search for `os-wireguard` and click **Install**.

### 2. Import the client config

- Go to **VPN** → **WireGuard** → **Endpoints**.
- Click **Import** and paste the `[Peer]` section of `client.conf`:

  ```
  PublicKey = <server-public-key>
  PresharedKey = <psk>
  Endpoint = <server-ip>:51820
  AllowedIPs = 0.0.0.0/0
  PersistentKeepalive = 25
  ```

- Click **Save**.

### 3. Create the local instance

- Go to **VPN** → **WireGuard** → **Local**.
- Click **Add**.
- Set **Enabled**, **Private Key** (from the `[Interface]` section of
  `client.conf`), **Listen Port** (any free port, e.g. 51821), and **Tunnel
  Address** (e.g. `10.8.0.2/24`).
- Under **Peers**, add the endpoint you created in step 2.
- Click **Save**, then **Apply**.

### 4. Create a gateway for the tunnel

- Go to **System** → **Gateways** → **Single**.
- Click **Add**.
- **Name**: `WG_VPN`
- **Interface**: select the WireGuard instance you created (e.g. `wg0`).
- **Address**: the tunnel IP (e.g. `10.8.0.2`).
- **Default Gateway**: **No** (do NOT set as default).
- **Disabled**: unchecked.
- Click **Save**, then **Apply**.

### 5. Route only one machine through the VPN (policy-based routing)

This creates a firewall rule that forces traffic from a specific LAN IP to
exit through the WireGuard tunnel instead of the WAN.

- Go to **Firewall** → **Rules** → **[LAN]**.
- Click **Add**.
- **Action**: `Pass`
- **Interface**: `LAN`
- **Source**: `Single host or network` → enter the machine's LAN IP
  (e.g. `192.168.1.100`).
- **Destination**: `Any` (all traffic from this machine goes through the VPN).
  > To route only specific traffic (e.g. streaming services), set Destination
  > to the IP ranges of those services.
- **Gateway**: select the `WG_VPN` gateway you created in step 4.
- **Description**: `Route media machine through WireGuard`
- Click **Save**, then **Apply changes**.

### 6. (Optional) NAT outbound for the tunnel

If the VPN server needs to see the traffic coming from the tunnel IP instead
of the machine's LAN IP:

- Go to **Firewall** → **NAT** → **Outbound**.
- Switch to **Hybrid Outbound NAT** mode.
- Click **Add**.
- **Interface**: `wg0`
- **Source**: the machine's LAN IP (e.g. `192.168.1.100`).
- **Destination**: `Any`
- **Translation**: `Interface address`
- **Description**: `NAT media machine traffic over WireGuard`
- Click **Save**, then **Apply**.

### 7. Verify

- Go to **VPN** → **WireGuard** → **Status**.
- Confirm the tunnel shows **Handshake** and recent transfer counters.
- On the routed machine, visit `ipinfo.io` — it should show the VPN server's
  public IP.
- Other machines on the LAN should still show their normal WAN IP.

## Troubleshooting

- **No handshake** → check the endpoint IP/port is reachable from OPNsense
  WAN. Verify the server's security group allows UDP 51820.
- **Machine still uses WAN IP** → verify the firewall rule is above any
  catch-all allow rules in the LAN tab (rules are processed top-to-bottom).
- **DNS leaks** → under **System** → **Settings** → **General**, set DNS
  servers to `1.1.1.1` and `1.0.0.1`. Or configure the routed machine to use
  those DNS servers directly.
- **Kill switch** → to block the routed machine's traffic if the VPN drops,
  create a LAN rule with Action `Reject` using the `WG_VPN` gateway as the
  target (place it right below the pass rule).