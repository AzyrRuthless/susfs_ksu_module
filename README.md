# SUSFS Module for KSU

![GitHub all releases](https://img.shields.io/github/downloads/AzyrRuthless/susfs_ksu_module/total)  
![Hits](https://hits.seeyoufarm.com/api/count/incr/badge.svg?url=https://github.com/AzyrRuthless/susfs_ksu_module&title=Views)

This project primarily builds upon the work of Simon, the original creator of SUSFS4KSU. Additionally, it incorporates features from the modules created by Sidex and backslashxx, along with original enhancements by myself.

## Introduction

This module installs userspace helper tools called **ksu_susfs** and **sus_su** into /data/adb/ and provides scripts to communicate with the SUS-FS kernel. This module provides root hiding for KernelSU on the kernel level, incorporating features from multiple sources to offer a comprehensive solution.

## Usage of ksu_susfs and Supported Features

- Run `ksu_susfs` in root shell for detailed usages.
- See `$KernelSU_repo/kernel/Kconfig` for supported features after applying the susfs patches.

## How to Disable Hiding Additional Traces

To disable hiding traces of Lineage, crDroid, GApps, etc., follow these steps:

1. Open the `boot-completed.sh` script located in the module's directory.
2. Locate the section with the lines that hide LineageOS & GApps traces. The lines are uncommented by default.
3. Comment out the relevant lines by adding a `#` at the beginning of each line.
4. Save the changes to the `boot-completed.sh` script.
5. Reboot your device for the changes to take effect.

## How to Disable Clean Vendor Sepolicy

To disable clean vendor sepolicy, which is enabled by default in the `service.sh` script, follow these steps:

1. Open the `service.sh` script located in the module's directory.
2. Locate the lines that enable clean vendor sepolicy. These lines are enabled by default.
3. Comment out the relevant lines by adding a `#` at the beginning of each line.
4. Save the changes to the `service.sh` script.
5. Reboot your device for the changes to take effect.

## Notes

- Ensure you have a custom kernel with SUS-FS patched in. Check the custom kernel source to confirm if it has SUS-FS.
- Use SUS-FS 1.4.2 for effective hiding.
- Do not mix/install with other root-hiding modules such as Shamiko or Zygisk Assistant.
- HideMyApplist is acceptable.
- Compatible with Revanced root module.
- Recommended to use Sidex's fork of [systemless-hosts-KernelSU-module by symbuzzer for systemless hosts](https://github.com/sidex15/systemless-hosts-KernelSU-module), or use the [bindhosts module by backslashxx](https://github.com/backslashxx/bindhosts).
- Initially uploaded for Miatoll users with Kinesis kernel version 4.9 or above, but should work for anyone with a SUSFS-patched kernel.
- Some features for hiding traces of Lineage, crDroid, GApps, etc., are available in the `boot-completed.sh` script & enabled by default.

## Other Known Issues

- You tell me, or kindly file an issue, or make a PR.

## Warning and Disclaimer

This is experimental code and can harm your system or cause performance issues. **USE AT YOUR OWN RISK!**
Modifying system files and policies can result in system instability or other issues.
Always back up your data before proceeding.

## FAQ

**Q: Why didn't you fork the original repository from Simon, Sidex, or Backslashxx?**

**A:** Simon, the original creator of SUSFS, hosts his repository on GitLab, while I prefer to use GitHub. Additionally, Backslashxx has now created a repository on GitHub. Creating a new repository on GitHub allowed me to combine features from Sidex's and Backslashxx's modules more efficiently. I also find it more comfortable to create a new, independent repository rather than working with forks. This approach provides more flexibility in organizing and enhancing the project, while still crediting all original authors for their foundational work.

## Credits

- [Simon](https://gitlab.com/simonpunk) for the original SUSFS4KSU project.
- [Sidex](https://github.com/sidex15) for additional features and original module modifications.
- [backslashxx](https://github.com/backslashxx) for further enhancements and modifications.

## License

This project is licensed under the terms of the GNU General Public License v3.0 (GPL-3.0). For more details, see the [LICENSE](LICENSE) file.
