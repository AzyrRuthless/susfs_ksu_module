### 2024-11-19
- Initial Releases

### 2024-12-01
- Added a function to check the presence of `susfs`, sourced from the Sidex module.  
- Moved functions for hiding custom ROM paths, Lineage, and GApps to `boot-completed.sh`.  
  - These features are now enabled by default. To disable them, simply comment out the corresponding lines.  
- Integrated Clean vendor sepolicy and Holmes 1.5+ Futile Trace Hide into `service.sh`, with credit to Backslash for the fix.  
  - Clean vendor sepolicy is also enabled by default. To disable it, comment out the relevant lines.  
- Refactored scripts for improved maintainability and readability.  

**Credits**:  
- Sidex: [https://github.com/sidex15/ksu_module_susfs](https://github.com/sidex15/ksu_module_susfs)  
- Backslashxx: [https://github.com/backslashxx/ksu_module_susfs](https://github.com/backslashxx/ksu_module_susfs)