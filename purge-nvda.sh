#!/bin/sh
# Script (purge-nvda.sh) by mac_editor @ egpu.io (mayankk2308@gmail.com)

# Usage:
# sudo ./purge-nvda.sh -> moves NVDA kexts to prevent NVDA GPU activation
# sudo ./purge-nvda.sh restore -> moves NVDA kexts back while keeping a backup - does not override newer versions.
# sudo ./purge-nvda.sh nvram-only -> update only NVRAM
# sudo ./purge-nvda.sh uninstall -> restores NVDA kexts and removes backup traces

operation="$1"
backup_dir="/Library/Application Support/Purge-NVDA/"
final_message=""
mkdir -p "$backup_dir"

invoke_kext_caching()
{
    echo "Invoke kext caching..."
    touch /System/Library/Extensions
}

update_nvram()
{
    echo "Updating NVRAM..."
    nvram fa4ce28d-b62f-4c99-9cc3-6815686e30f9:gpu-power-prefs=%01%00%00%00
    final_message="Complete. iGPU will be preferred on boot if dGPU drivers are unavailable."
}

move_nvda_drv()
{
    if [[ "$(ls /System/Library/Extensions/ | grep NVDA)" && "$(ls /System/Library/Extensions/ | grep GeForce)" ]]
    then
      echo "Moving NVIDIA drivers..."
      if [[ "$(ls "$backup_dir")" ]]
      then
        rm -r "$backup_dir"*
      fi
      mv /System/Library/Extensions/NVDA*.kext "$backup_dir"
      mv /System/Library/Extensions/GeForce*.* "$backup_dir"
      update_nvram
      final_message="Complete. Your mac will now behave as an iGPU-only device."
    else
    final_message="Kexts already moved. No action required."
    fi
}

restore_nvda_drv()
{
    echo "Restoring NVIDIA drivers..."
    rsync -r -u "$backup_dir"* /System/Library/Extensions/
    final_message="Complete. Restart to reinstate default behavior."
}

uninstall()
{
    if [[ "$(ls "$backup_dir")" ]]
    then
        restore_nvda_drv
        invoke_kext_caching
        echo "Uninstalling..."
        rm -r "$backup_dir"
        nvram -c
        final_message="Uninstallation complete."
    else
        final_message="Cannot uninstall - no installation found."
    fi
}

if [[ "$operation" == "" ]]
then
  move_nvda_drv
  invoke_kext_caching
elif [[ "$operation" == "restore" ]]
then
  restore_nvda_drv
  invoke_kext_caching
elif [[ "$operation" == "nvram-only" ]]
then
  update_nvram
elif [[ "$operation" == "uninstall" ]]
then
    uninstall
fi

echo "$final_message"
