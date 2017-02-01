#!/usr/bin/env bash
IMAGE='dd-wrt_public_vga.image'
IMAGE_URL="http://dd-wrt.com/routerdb/de/download/X86/X86///dd-wrt_public_vga.image/3744"
VDI="$IMAGE.vdi"
VM=$1
CONTROLLER_NAME='IDE'
MEMORY='512'    # this is quite generous
DISK_SIZE='256' # this one too
IP_NET=$2
IP="$IP_NET.254"
NET_ADAPTER='vboxnet0'

wget "$IMAGE_URL" "--output-file=$IMAGE"
vboxmanage convertdd $IMAGE $VDI
rm $IMAGE
vboxmanage modifyhd $VDI --resize $DISK_SIZE

vboxmanage createvm --name "$VM" --register

vboxmanage storagectl "$VM" --name $CONTROLLER_NAME --add ide --controller PIIX4
vboxmanage storageattach "$VM" --storagectl $CONTROLLER_NAME --device 0 --port 0 --type hdd --medium $VDI

vboxmanage modifyvm "$VM" --memory $MEMORY

vboxmanage hostonlyif create
vboxmanage hostonlyif ipconfig $NET_ADAPTER --ip $IP --netmask '255.255.255.0'
vboxmanage modifyvm "$VM" --hostonlyadapter1 $NET_ADAPTER