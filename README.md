# Purge-NVDA
A simple script for Macs that purges the activation of the discrete **NVIDIA** GPUs on **macOS** and by extension enables **AMD external graphics** support.

## Requirements
This script requires the following specifications:
* Mac with integrated Intel GPU + discrete **NVIDIA** GPU
* **macOS Mavericks** or later

For AMD eGPU support:
* **macOS 10.13 Beta 4**
* **macOS 10.13.4 Beta 1**

It is recommended that you have a backup of the system. Testing was done on a **Mid-2014 MacBook Pro w/ GeForce GT 750M**.

## Usage
Please follow these steps:

### Step 1
Disable **system integrity protection** for macOS using **Terminal** in **Recovery**:
```bash
$ csrutil disable
$ reboot
```

### Step 2
Boot back into macOS and run the following commands:
```bash
$ cd /path/to/script/purge-nvda.sh
$ sudo chmod +x purge-nvda.sh
$ sudo ./purge-nvda.sh
```

Your mac will now behave like an iGPU-only device.

## Troubleshooting
If you are unable to boot into macOS, boot into recovery, launch **Terminal** and type in the following commands:
```bash
$ nvram -c
$ cd /Volumes/<boot_disk_name>
$ mv Library/Application\ Support/Purge-NVDA/* System/Library/Extensions/
$ reboot
```

After rebooting, **uninstall** the script.

## Additional Options
If you do not require **AMD eGPU** support:
```bash
$ sudo ./purge-nvda.sh suppress-only
```

To update the **NVRAM** only:
```bash
$ sudo ./purge-nvda.sh nvram-only
```

This is useful for **iGPU-only** mode for the next boot only. Rebooting again will restore default behavior.

To uninstall changes:
```bash
$ sudo ./purge-nvda.sh uninstall
```

For help with how to use the script in the command line:
```bash
$ sudo ./purge-nvda.sh help
```

**Uninstallation recommended before updating macOS.**

## References
Due credit goes to the MacRumors members (esp. **@nsgr**) for the **NVRAM** settings that make this possible without requiring a separate **ArchLinux** installation to manually manage these values.

## Disclaimer
This script moves core system files associated with macOS. While any of the potential issues with its application are recoverable, please use this script at your discretion. I will not be liable for any damages to your operating system.

## License
This project is available under the **MIT** license. See the license file for more information.
