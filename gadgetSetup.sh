#!/bin/bash

# TO-DO each of these should be fetched form a config file, not hard coded
# product information
PRODUCT_ID="0x0505"
PRODUCT_NAME="RØDECASTER PRO 2"
VENDOR_ID="0x19F7"
VENDOR_NAME="RØDE Microphones"
SERIAL_NUMBER="1234RØDE "

# message properties
PROTOCOL="0"
SUBCLASS="0"
#REPORT_LENGTH="8"
REPORT_LENGTH="256"

CONFIGFS_DIR="/sys/kernel/config/"
GADGET_DIR="${CONFIGFS_DIR}/usb_gadget/g1/"
HID_FUNCTION_DIR="${GADGET_DIR}/functions/hid.usb0/"
CONFIG_DIR="${GADGET_DIR}/configs/c.1/"
STRINGS_DIR="${GADGET_DIR}/strings/0x409/"
CONFIG_STRINGS_DIR="${CONFIG_DIR}/strings/0x409/"

# setup composite device
modprobe libcomposite
mount none "${CONFIGFS_DIR}" -t configfs
mkdir -p "${CONFIG_DIR}"
mkdir -p "${GADGET_DIR}"

# setup HID
mkdir -p "${HID_FUNCTION_DIR}"
echo "${PROTOCOL}" > "${HID_FUNCTION_DIR}/protocol"
echo "${SUBCLASS}" > "${HID_FUNCTION_DIR}/subclass"
echo "${REPORT_LENGTH}" > "${HID_FUNCTION_DIR}/report_length"
cat rodecaster.hid > "${HID_FUNCTION_DIR}/report_desc"

# general setup
mkdir -p "${STRINGS_DIR}"
mkdir -p "${CONFIG_STRINGS_DIR}"
echo "${PRODUCT_ID}" > "${GADGET_DIR}/idProduct"
echo "${VENDOR_ID}" > "${GADGET_DIR}/idVendor"
echo "${SERIAL_NUMBER}" > "${STRINGS_DIR}/serialnumber"
echo "${VENDOR_NAME}" > "${STRINGS_DIR}/manufacturer"
echo "${PRODUCT_NAME}" > "${STRINGS_DIR}/product"
echo "Conf 1" > "${CONFIG_STRINGS_DIR}/configuration"
ln -s "${HID_FUNCTION_DIR}" "${CONFIG_DIR}"
echo 20980000.usb > "${GADGET_DIR}/UDC"

