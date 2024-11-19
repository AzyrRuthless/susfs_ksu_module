# SUSFS Module for KSU

![GitHub all releases](https://img.shields.io/github/downloads/AzyrRuthless/susfs_ksu_module/total)  
![Hits](https://hits.seeyoufarm.com/api/count/incr/badge.svg?url=https://github.com/AzyrRuthless/susfs_ksu_module&title=Views)

This project primarily builds upon the work of Simon, the original creator of SUSFS4KSU. Additionally, it incorporates features from the modules created by Sidex and backslashxx, along with original enhancements by myself. The foundation and many base scripts are directly inspired by Simon’s [SUSFS4KSU project](https://gitlab.com/simonpunk/susfs4ksu).

## Introduction

This module installs userspace helper tools called **ksu_susfs** and **sus_su** into /data/adb/ and provides scripts to communicate with the SUS-FS kernel. This module provides root hiding for KernelSU on the kernel level, incorporating features from multiple sources to offer a comprehensive solution.

## Usage of ksu_susfs and Supported Features

- Run `ksu_susfs` in root shell for detailed usages.
- See `$KernelSU_repo/kernel/Kconfig` for supported features after applying the susfs patches.

## How to Enable Hiding Additional Traces

To enable hiding traces of Lineage, crDroid, GApps, etc., follow these steps:

1. Open the `post-fs-data.sh` script located in the module's directory.
2. Locate the section with the lines that hide LineageOS traces. The lines are commented out by default.
3. Uncomment the relevant lines by removing the `#` at the beginning of each line.
4. Save the changes to the `post-fs-data.sh` script.
5. Reboot your device for the changes to take effect.

## Notes

- Ensure you have a custom kernel with SUS-FS patched in. Check the custom kernel source to confirm if it has SUS-FS.
- Use SUS-FS 1.4.2 for effective hiding.
- Do not mix/install with other root-hiding modules such as Shamiko or Zygisk Assistant.
- HideMyApplist is acceptable.
- Compatible with Revanced root module.
- Recommended to use Sidex's fork of [systemless-hosts-KernelSU-module by symbuzzer for systemless hosts](https://github.com/sidex15/systemless-hosts-KernelSU-module), or use the [bindhosts module by backslashxx](https://github.com/backslashxx/bindhosts).
- Initially uploaded for Miatoll users with Kinesis kernel version 4.9 or above, but should work for anyone with a SUSFS-patched kernel.
- Some features for hiding traces of Lineage, crDroid, GApps, etc., are available in the post-fs-data.sh script but are disabled by default.

## Other Known Issues

- You tell me, or kindly file an issue, or make a PR.

## Warning and Disclaimer

This is experimental code and can harm your system or cause performance issues. **USE AT YOUR OWN RISK!**
Modifying system files and policies can result in system instability or other issues.
Always back up your data before proceeding.

## FAQ

**Q: Why didn't you fork the original repository from Simon, Sidex, or Backslashxx?**

**A:** Simon, the original creator of SUSFS, hosts his repository on GitLab, while I prefer to use GitHub. Additionally, backslashxx has not created a repository on GitHub. Creating a new repository on GitHub allowed me to combine features from Sidex's and backslashxx's modules more efficiently. This approach provides more flexibility in organizing and enhancing the project, while still crediting all original authors for their foundational work.

## Credits

- [Simon](https://gitlab.com/simonpunk) for the original SUSFS4KSU project.
- [Sidex](https://github.com/sidex15) for additional features and original module modifications.
- [backslashxx](https://github.com/backslashxx) for further enhancements and modifications.

## License

This project is licensed under the terms of the GNU General Public License v3.0 (GPL-3.0). For more details, see the [LICENSE](LICENSE) file.
