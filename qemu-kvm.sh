#!/bin/sh

pkgs_base='qemu-kvm libvirt-bin bridge-utils'
pkgs_gui='virt-manager'

sudo apt-get install $pkgs_base $pkgs_gui
