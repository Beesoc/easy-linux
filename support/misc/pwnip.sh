#!/bin/bash
# Script to set a static IP address for the usb0 interface when a specific USB device is inserted
# Version: 0.0.4

# Define the USB device identifier
USB_DEVICE_ID=$(echo "0525:a4a2") # Replace with the actual USB device ID

# Define the static IP address configuration
IP_ADDRESS="10.0.0.1"   # Replace with the desired IP address
NETMASK="255.255.255.0" # Replace with the desired netmask

# Check if the USB device is connected
if [[ $(lsusb | grep "$USB_DEVICE_ID") ]]; then
	# USB device is connected, configure the static IP address
	printf "USB device detected. Configuring static IP address for usb0 interface.\n"

	# Set the IP address and netmask
	sudo ip addr add $IP_ADDRESS/$NETMASK dev usb0

	# Bring up the usb0 interface
	sudo ip link set usb0 up

	# Optional: Add default gateway if needed
	GATEWAY="10.0.0.1" # Replace with the desired gateway IP address
	sudo ip route add default via $GATEWAY dev usb0
else
	printf "USB device not found.\n"
fi
