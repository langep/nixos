# Steam machine installation

This host is a TV gaming PC with an Intel CPU and an NVIDIA RTX 2080. It
provides both a normal Hyprland desktop and a controller-friendly Steam
Gamescope session. Moonlight is installed for streaming games from the
desktop's Sunshine server.

## 1. Boot the NixOS installer

Boot a recent NixOS installer in UEFI mode and connect the machine to the
network. Partition and format the target disk, then mount the new root
filesystem at `/mnt` and the EFI System Partition at `/mnt/boot`.

The repository intentionally does not prescribe partitioning commands because
device names and existing disk contents vary. Verify the target disk carefully
before formatting anything.

## 2. Make this repository available

Clone or copy this repository into the installer environment. The examples
below assume it is located at `/tmp/nixos`:

```console
git clone <repository-url> /tmp/nixos
cd /tmp/nixos
```

If the repository is private, copying it from another machine may be easier
than authenticating from the installer.

## 3. Generate the hardware configuration

Generate configuration from the mounted filesystems:

```console
sudo nixos-generate-config --root /mnt
```

Replace the checked-in placeholder with the generated hardware file:

```console
cp /mnt/etc/nixos/hardware-configuration.nix \
  /tmp/nixos/hosts/steam-machine/hardware-configuration.nix
```

Review the generated file and confirm that:

- `/` points to the intended root filesystem;
- `/boot` points to the EFI System Partition;
- the filesystem types are correct;
- `kvm-intel` is present in `boot.kernelModules`.

Do not install using the placeholder disk labels in the original file unless
the filesystems were deliberately created with those labels.

## 4. Install

From the repository root, evaluate the host and start the installation:

```console
nix eval path:.#nixosConfigurations.steam-machine.config.system.build.toplevel.drvPath
sudo nixos-install --flake path:.#steam-machine
```

The installer may prompt for the root password. Set the `langep` user's
password separately before rebooting:

```console
sudo nixos-enter --root /mnt -c 'passwd langep'
```

Reboot after the installer completes:

```console
sudo reboot
```

## 5. First boot

The login screen offers the regular Hyprland desktop and the Steam Gamescope
session. Use Hyprland for administration and desktop applications; use the
Gamescope session for the TV-oriented Steam interface.

In Hyprland:

1. Open Blueman from the application launcher and pair Bluetooth controllers.
2. Start Sunshine on the desktop with `systemctl --user start sunshine`.
3. Open Moonlight. The desktop should be discovered automatically over mDNS.
4. Select the desktop and enter Moonlight's pairing PIN in the Sunshine web UI
   on the desktop.
5. Test audio, controller input, and the intended TV resolution and refresh
   rate before switching to the Gamescope session.

Wi-Fi connections can be selected from the NetworkManager icon in Waybar's
system tray.

## Updating the host

After pulling configuration changes, rebuild with:

```console
sudo nixos-rebuild switch --flake /path/to/nixos#steam-machine
```

Keep the generated `hardware-configuration.nix` for this physical machine. It
should only need regeneration after storage or other significant hardware
changes.
