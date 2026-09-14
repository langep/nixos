# Secure Boot runbook: NixOS and Windows

This runbook configures a complete NixOS Secure Boot chain with Lanzaboote while
retaining the Microsoft certificates needed to boot Windows and signed hardware
option ROMs.

## Machine layout and current state

- Motherboard: MSI MAG X870E TOMAHAWK WIFI (MS-7E59)
- Firmware: AMI/MSI, BIOS version `2.AC4` dated 2026-09-02
- NixOS: `/dev/nvme2n1`, with its 1 GiB EFI System Partition mounted at `/boot`
- Windows: `/dev/nvme0n1`, with a separate 100 MiB EFI System Partition
- Boot mode: UEFI
- Firmware and the running NixOS kernel currently report Secure Boot enabled
- Use the MSI `F11` boot menu to select Windows Boot Manager if it is not shown
  in the NixOS boot menu

The repository has already been prepared with Lanzaboote v1.1.0:

- `flake.nix` contains the Lanzaboote input and desktop module.
- `hosts/desktop/default.nix` disables the ordinary systemd-boot module, enables
  Lanzaboote, uses `/var/lib/sbctl`, and installs `sbctl`.
- `flake.lock` contains the locked Lanzaboote dependencies.
- The relevant Nix options have been evaluated successfully.

## Progress checklist

Mark each completed item before rebooting. Resume at the first unchecked item.

- [ ] Windows Secure Boot and TPM state checked
- [ ] BitLocker recovery key saved somewhere outside this computer
- [ ] BitLocker protection suspended
- [ ] NixOS signing keys created
- [ ] MSI firmware placed in Secure Boot Setup Mode by deleting only the PK
- [ ] Lanzaboote configuration installed with `nixos-rebuild`
- [ ] NixOS and Microsoft/firmware keys enrolled
- [ ] NixOS verified after reboot with Secure Boot enabled
- [ ] Windows verified and BitLocker protection resumed

## 1. Prepare Windows and BitLocker

Boot Windows using the MSI `F11` boot menu. Open `msinfo32` and confirm:

```text
BIOS Mode: UEFI
Secure Boot State: On
```

Run `tpm.msc` and confirm:

```text
Specification Version: 2.0
The TPM is ready for use
```

Open a terminal as Administrator and inspect BitLocker:

```powershell
manage-bde -status C:
manage-bde -protectors -get C:
```

Before proceeding, save the BitLocker recovery key somewhere outside this
computer. Then suspend protection until it is explicitly resumed:

```powershell
manage-bde -protectors -disable C: -RebootCount 0
```

Do not clear or reset the TPM.

After completing this section, mark the first three checklist items and reboot
into NixOS.

## 2. Create the NixOS signing keys

In NixOS:

```bash
cd /home/langep/nixos
nix shell nixpkgs#sbctl -c sudo sbctl create-keys
sudo sbctl status
```

The keys should now exist under `/var/lib/sbctl`. The private keys must remain
private. An encrypted offline backup is useful, but never commit them to this
repository.

Mark the signing-key checklist item. Do **not** run `nixos-rebuild` yet.

## 3. Put the MSI firmware into Setup Mode

Enter firmware setup from NixOS:

```bash
sudo systemctl reboot --firmware-setup
```

In the MSI firmware, press `F7` for Advanced mode if necessary. The menu should
be approximately:

```text
Settings
└── Security
    └── Secure Boot
```

Set:

```text
Secure Boot: Enabled
Secure Boot Mode: Custom
```

Then select:

```text
Key Management
└── Platform Key (PK)
    └── Delete Key
```

Important:

- Delete only the **Platform Key (PK)**.
- Do not choose **Delete all Secure Boot variables**.
- Do not clear the TPM.
- Deleting only the PK enters Setup Mode while avoiding deliberate deletion of
  the revocation database (`dbx`).

Save changes and boot NixOS. Setup Mode permits the existing boot path to run.

## 4. Install Lanzaboote and enroll keys

First confirm that the firmware is in Setup Mode:

```bash
sudo sbctl status
```

Do not continue unless the output reports Setup Mode enabled. Then install the
prepared configuration:

```bash
cd /home/langep/nixos
sudo nixos-rebuild switch --flake .#desktop
sudo sbctl verify
```

Enroll the locally owned keys while retaining Microsoft and firmware-provided
trust. Microsoft trust is required for Windows and may be required by the GPU's
option ROM:

```bash
sudo sbctl enroll-keys --microsoft --firmware-builtin
sudo sbctl status
```

The enrollment should change the machine out of Setup Mode. Reboot:

```bash
sudo reboot
```

If enrollment fails, do not use an option such as
`--yes-this-might-brick-my-machine`. Record the exact error and stop here.

## 5. Verify NixOS after reboot

Run:

```bash
sudo sbctl status
bootctl status
sudo sbctl verify
journalctl -b -k | grep -i "secure boot"
```

Expected status:

```text
Setup Mode: Disabled
Secure Boot: Enabled
```

Lanzaboote's unified kernel images and boot executables should be signed. Some
unused legacy kernel artifacts under `EFI/nixos` can be reported as unsigned;
concentrate on the unified images actually installed by Lanzaboote.

If Secure Boot remains disabled after successful enrollment, enter MSI firmware
setup and set `Secure Boot: Enabled`, leaving the mode/key databases intact.

## 6. Verify Windows and resume BitLocker

Use `F11` during startup and select Windows Boot Manager. In `msinfo32`, confirm:

```text
BIOS Mode: UEFI
Secure Boot State: On
```

Run `tpm.msc` and confirm that TPM 2.0 remains ready. In an Administrator
terminal, resume and verify BitLocker:

```powershell
manage-bde -protectors -enable C:
manage-bde -status C:
```

The process is complete once Windows reports Secure Boot on, TPM 2.0 ready, and
BitLocker protection enabled.

## Recovery notes

- If Windows asks for BitLocker recovery, enter the recovery key saved in step
  1. Do not clear the TPM.
- If NixOS does not appear, use `F11` and select the NixOS/systemd-boot entry or
  its EFI disk directly.
- If Windows does not appear in the NixOS menu, that is not necessarily a
  failure: its EFI partition is on another drive. Use the MSI `F11` menu.
- If neither signed OS boots, enter firmware setup, restore/enroll the factory
  default Secure Boot keys, and boot Windows. This removes trust in the custom
  NixOS key, so repeat the Setup Mode and enrollment sections afterward.
- Keep a NixOS installer/recovery USB available before changing firmware keys.

## References

- [Lanzaboote: prepare your system](https://github.com/nix-community/lanzaboote/blob/master/docs/getting-started/prepare-your-system.md)
- [Lanzaboote: enable Secure Boot](https://github.com/nix-community/lanzaboote/blob/master/docs/getting-started/enable-secure-boot.md)
- [MSI AMD AM5 BIOS manual](https://download-2.msi.com/archive/mnu_exe/mb/AMDAM5BIOS.pdf)
- [Microsoft BitLocker FAQ](https://learn.microsoft.com/en-us/windows/security/operating-system-security/data-protection/bitlocker/faq)
- [Microsoft Windows 11 and Secure Boot](https://support.microsoft.com/en-us/windows/security/devicesecurity/windows-11-and-secure-boot)
