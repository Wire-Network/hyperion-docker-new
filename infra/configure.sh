#!/bin/sh

# Check if the vm.max_map_count setting is already set
if ! grep -q "vm.max_map_count=262144" /etc/sysctl.conf; then
    # Append the setting if it doesn't exist
    echo "vm.max_map_count=262144" | sudo tee -a /etc/sysctl.conf > /dev/null
    echo "vm.max_map_count has been set to 262144."
else
    echo "vm.max_map_count is already set to 262144."
fi

# Apply the sysctl settings
sudo sysctl -p