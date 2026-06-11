# VPN solution research

## Evaluation criteria

| Criterion              | Weight | Notes                                      |
|------------------------|--------|--------------------------------------------|
| Android / Google TV app | High   | Must be installable on TV (Play Store / APK) |
| Linux proxy mode        | Medium | SOCKS5 / HTTP / tun — for power users      |
| OPNsense integration    | Medium | Plugin or package available                |
| HD streaming overhead   | High   | <5% CPU, <10% MTU overhead                 |
| Ease of automation      | High   | Terraform-friendly, headless setup         |
| Security / audit        | Medium | Modern crypto, no known backdoors          |

## Candidates

### 1. WireGuard ⭐

| Aspect            | Assessment                                    |
|-------------------|-----------------------------------------------|
| Android TV        | ✅ Official app on Play Store, config via QR  |
| Linux proxy       | ⚠️ No built-in SOCKS/HTTP — use `wg-quick` + `socat` / nftables redirect, or run a separate proxy behind the tunnel |
| OPNsense          | ✅ Built-in plugin (os-wireguard)             |
| Overhead          | Minimal (~4% for tunnel, kernel-level)        |
| Automation        | ✅ `wg genkey` / config file generation       |
| Crypto            | ✅ Curve25519, ChaCha20Poly1305, BLAKE2s      |

**Verdict**: Strongest candidate. Lightest overhead, native app on Android TV,
OPNsense plugin. The only gap is Linux proxy mode — trivial to work around.

### 2. OpenVPN

| Aspect            | Assessment                                    |
|-------------------|-----------------------------------------------|
| Android TV        | ✅ OpenVPN Connect on Play Store              |
| Linux proxy       | ⚠️ Can route through tun, but no built-in SOCKS — similar workaround as WireGuard |
| OPNsense          | ✅ Business Edition / os-openvpn plugin       |
| Overhead          | Medium (~10-15%, TLS handshake, user-space)   |
| Automation        | ✅ Well-known, easy to script                 |
| Crypto            | ✅ OpenSSL-based, multiple cipher options     |

**Verdict**: Battle-tested, widest client support, but higher overhead. HD
streaming may be more taxing on a tiny VM.

### 3. Tailscale / Headscale

| Aspect            | Assessment                                    |
|-------------------|-----------------------------------------------|
| Android TV        | ⚠️ Tailscale on Android, but no native Google TV app — side-loadable? |
| Linux proxy       | ✅ Tailscale serve / Funnel (HTTP proxy)      |
| OPNsense          | ⚠️ Tailscale plugin available, but not native Headscale integration |
| Overhead          | Low (WireGuard-based)                         |
| Automation        | ✅ Tailscale API / headscale CLI              |
| Crypto            | ✅ WireGuard-based                            |

**Verdict**: Great UX, but dependency on Tailscale coordinator (or self-hosted
Headscale). Android TV support is unclear — may need side-loading. Not as
simple as a raw WireGuard config.

### 4. SoftEther

| Aspect            | Assessment                                    |
|-------------------|-----------------------------------------------|
| Android TV        | ❌ No official Android app                    |
| Linux proxy       | ✅ Built-in OpenVPN / L2TP / SSTP / proxy     |
| OPNsense          | ⚠️ Community plugin, not first-class          |
| Overhead          | Medium                                        |
| Automation        | ⚠️ Complex config, many protocols             |
| Crypto            | ✅ Modern ciphers supported                   |

**Verdict**: Overkill for a single-client use case. Lack of Android TV support
is a dealbreaker.

## Decision

**WireGuard** is the recommended VPN solution because:
1. Native Android TV app with QR-code config import.
2. OPNsense plugin (`os-wireguard`) is first-class.
3. Lowest CPU and bandwidth overhead — critical for HD streaming on a burstable
   VM.
4. Trivially automatable (keygen + config file + QR code).
5. Linux proxy gap is easily bridged with a simple `socat` or `haproxy` wrapper
   behind the tunnel interface.

OpenVPN is the fallback if WireGuard is blocked by a network (e.g., corporate
firewalls that DPI WireGuard).