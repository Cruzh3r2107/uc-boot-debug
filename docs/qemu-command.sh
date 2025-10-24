#!/bin/bash
# QEMU boot command for Ubuntu Core image

qemu-system-x86_64 \
 -enable-kvm \
 -smp 2 \
 -m 4096 \
 -machine q35 \
 -cpu host \
 -global ICH9-LPC.disable_s3=1 \
 -device virtio-vga \
 -display gtk \
 -net nic,model=virtio \
 -net user,hostfwd=tcp::8022-:22 \
 -drive file=OVMF_CODE_4M.secboot.fd,if=pflash,format=raw,unit=0,readonly=on \
 -drive file=OVMF_VARS_4M.ms.fd,if=pflash,format=raw,unit=1 \
 -drive "file=pc.img",if=none,format=raw,id=disk1 \
 -device virtio-blk-pci,drive=disk1,bootindex=1
