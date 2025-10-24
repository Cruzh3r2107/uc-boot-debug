#!/bin/bash
# Image build command

UBUNTU_STORE_AUTH=$(cat store.auth) ubuntu-image snap \
  iotdevice-model-vish.assert \
  --output pc.img \
  --debug
