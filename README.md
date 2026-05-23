# easy-fasm-ls

A lightweight, high-performance, and minimal 64-bit x86-64 Assembly directory listing utility for Linux, built using Flat Assembler (FASM).

Developed by **Syn4pse773**.

---

## Overview

`easy-fasm-ls` is an ultra-fast, dependency-free directory listing utility designed for x86-64 Linux environments. It leverages native Linux kernel system calls to directly query the filesystem, bypassing standard dynamic libraries like `glibc`. 

By working directly with the Linux ABI and implementing custom FASM macros, this utility demonstrates the absolute peak of minimal binary size and raw execution speed.

---

## Features

- **Direct System Calls**: Completely dependency-free implementation, interacting directly with the Linux kernel via the x86-64 `syscall` instruction.
- **Robust Chunk-Based Parsing**: Efficiently parses the variable-length `linux_dirent64` structure returned by the `sys_getdents64` system call.
- **Memory-Safe Register Utilization**: Highly optimized CPU register usage adhering to the System V AMD64 ABI convention.
- **Custom Macro Integration**: Integrates standard kernel definitions, system call wrappers, and helper macros through `std.inc`.
- **Minimal Binary Footprint**: Produces a tiny, static ELF64 executable with zero overhead.

---

## Technical Architecture

The utility performs the following sequential actions:
1. **Open Directory**: Opens the current directory (`.`) using the `sys_open` system call with `O_RDONLY | O_DIRECTORY` flags.
2. **Buffer Read Loop**: Performs chunked reads using the `sys_getdents64` system call into a local 1024-byte buffer.
3. **Parse and Print**: Iterates through the variable-length `linux_dirent64` records:
   - Extract the record length (`d_reclen`).
   - Extract the null-terminated filename (`d_name`).
   - Compute string length and output the name using `sys_write` via standard output.
4. **Graceful Exit**: Closes the directory file descriptor and exits gracefully using `sys_exit` with appropriate status codes.

---

## Directory Structure

- `myls.asm` - The main assembly source file.
- `std.inc` - Custom standard inclusion containing kernel system call macros and standard constants.
- `test.sh` - Automated test suite verifying directory listing matching.
- `LICENSE` - MIT License documentation.

---

## Installation & Compilation

### Prerequisites

You must have the **Flat Assembler (FASM)** installed and available in your environment path.

### Build Instructions

To compile the assembly source file into a static ELF64 executable, execute:

```bash
fasm myls.asm myls
```

### Execution

To run the utility and display the directory contents:

```bash
./myls
```

---

## Testing

An automated shell script `test.sh` is provided to verify the correctness of the directory listing against the standard GNU `ls` utility.

To run the tests, execute:

```bash
chmod +x test.sh
./test.sh
```

---

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

Copyright (c) 2026 Syn4pse773.
