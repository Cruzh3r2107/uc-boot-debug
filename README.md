# Ubuntu Core 24 Boot Failure - Debug Repository

## Problem
Ubuntu Core 24 custom image fails to boot with `snapd.failure.service` timeout error.

## Error
```
snapd.failure.service - Failure handling of the snapd snap
Job snapd.service/start running (1min 13s / 1min 30s)
```
System never completes first boot and hangs at this error.

## Files

### `/snap/`
Complete gadget snap source directory:
- `snapcraft.yaml` - Gadget snap build configuration
- `gadget.yaml` - Partition layout and sizes  
- `hooks/` - Any prepare-device or configure hooks
- Other gadget snap source files

### `/model/`
- **iotdevice-model-vish.assert** - Signed model assertion (7 snaps)

### `/docs/`
- **qemu-command.sh** - QEMU boot command
- **build-command.sh** - Image build command
- **boot-error.txt** - Serial console error output

## Current Configuration

### Model Snaps (7 total)
1. `iotdevice-vishwanathsingh-tasks-pc` (gadget, rev 3)
2. `pc-kernel` (24/stable)
3. `core22` (base)
4. `core24` (base, primary)
5. `snapd` (latest/stable, rev 25202) ⚠️
6. `console-conf`
7. `landscape-client`

### QEMU Setup
- RAM: 4GB
- CPU: 2 cores
- Graphics: virtio-vga with GTK display
- UEFI: OVMF SecureBoot enabled
- Network: Port 8022 → 22 (SSH)

## Questions for Review

1. **Is snapd rev 25202 the buggy 3.72 version?** Which revision should I pin?
2. **Are partition sizes correct?** Check `snap/gadget.yaml` ubuntu-seed size for 7-11 snaps
3. **Does image need truncation?** If so, what size?
4. **Any issues with hooks?** Check `snap/hooks/` if present

## What We've Tried

✅ Minimal model (7 snaps only)  
✅ Increased resources (4GB RAM, 2 CPU)  
✅ Removed TPM emulator  
✅ Tested without extra snaps  
✅ Used specific gadget revision (3)  
❌ **Same error every time**

## Build Process
```bash
# Build gadget snap
cd snap/
snapcraft

# Build Ubuntu Core image
UBUNTU_STORE_AUTH=$(cat store.auth) ubuntu-image snap \
  iotdevice-model-vish.assert \
  --output pc.img

# Boot
qemu-system-x86_64 -enable-kvm -smp 2 -m 4096 \
  -device virtio-vga -display gtk \
  -drive file=pc.img,if=virtio,format=raw
```

## Help Needed

Please review:
- **snap/gadget.yaml** - Partition sizes (especially ubuntu-seed)
- **snap/hooks/** - Any hook issues
- **model/** - Snap selection and versions
- Recommended snapd revision to pin

---

**Goal:** Deploy Ubuntu Frame + Chromium kiosk on Ubuntu Core 24 in QEMU
