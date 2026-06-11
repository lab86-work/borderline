#cloud-config
package_update: true
packages:
  - wireguard
  - qrencode
  - iptables

write_files:
  - path: /opt/wireguard/setup.sh
    content: |
      #!/bin/bash
      set -euo pipefail

      WG_DIR=/etc/wireguard
      CLIENT_DIR=/opt/wireguard/clients
      SERVER_PRIV="$$WG_DIR/server.key"
      SERVER_PUB="$$WG_DIR/server.pub"

      mkdir -p "$$WG_DIR" "$$CLIENT_DIR"
      chmod 700 "$$WG_DIR" "$$CLIENT_DIR"

      if [ ! -f "$$SERVER_PRIV" ]; then
        umask 077
        wg genkey | tee "$$SERVER_PRIV" | wg pubkey > "$$SERVER_PUB"
      fi

      SERVER_KEY=$$(cat "$$SERVER_PRIV")
      WG_PORT=${wireguard_port}

      cat > "$$WG_DIR/wg0.conf" << WGEOCONF
  [Interface]
  PrivateKey = $$SERVER_KEY
  Address = ${vpn_subnet}.1/24
  ListenPort = $$WG_PORT
  PostUp = iptables -A FORWARD -i wg0 -j ACCEPT; iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
  PostDown = iptables -D FORWARD -i wg0 -j ACCEPT; iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE
  WGEOCONF

      CLIENT_PRIV=$$(wg genkey)
      CLIENT_PUB=$$(echo "$$CLIENT_PRIV" | wg pubkey)
      CLIENT_PSK=$$(wg genpsk)

      cat > "$$CLIENT_DIR/client.conf" << CLICONF
  [Interface]
  PrivateKey = $$CLIENT_PRIV
  Address = ${vpn_subnet}.2/24
  DNS = 1.1.1.1, 1.0.0.1

  [Peer]
  PublicKey = $$(cat "$$SERVER_PUB")
  PresharedKey = $$CLIENT_PSK
  Endpoint = ${public_ip}:$$WG_PORT
  AllowedIPs = 0.0.0.0/0
  PersistentKeepalive = 25
  CLICONF

      cat "$$CLIENT_DIR/client.conf" | qrencode -t ansiutf8 > "$$CLIENT_DIR/client.qr" 2>/dev/null || true

      {
        echo ""
        echo "[Peer]"
        echo "PublicKey = $$CLIENT_PUB"
        echo "PresharedKey = $$CLIENT_PSK"
        echo "AllowedIPs = ${vpn_subnet}.2/32"
      } >> "$$WG_DIR/wg0.conf"

runcmd:
  - bash /opt/wireguard/setup.sh
  - sysctl -w net.ipv4.ip_forward=1
  - echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
  - systemctl enable wg-quick@wg0
  - systemctl start wg-quick@wg0