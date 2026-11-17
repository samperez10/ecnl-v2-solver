# ECNL Solver V2

Source-free installers and release binaries for ECNL Solver V2.

## Ubuntu, Alpine, and Termux

```sh
curl -fsSL https://raw.githubusercontent.com/samperez10/ecnl-v2-solver/main/install.sh | sh
```

After installation, start the app with:

```sh
ecnl-v2
```

The installer also provides `ecnl-solver-v2` as a compatibility alias.

Supported packages:

- Ubuntu 22.04: x86_64, aarch64, and armhf (including Orange Pi)
- Ubuntu 24.04: x86_64
- Alpine 3.23: x86_64 and aarch64
- Termux: aarch64

## Windows

[Download ECNL Solver V2 for Windows (portable x86_64 EXE)](https://github.com/samperez10/ecnl-v2-solver/releases/latest/download/ECNLSolver-Portable-x86_64.exe)

It is a single portable executable and does not install application source. The link always downloads the latest published version.

## Integrity

Every release artifact includes a SHA-256 checksum. The shell installer verifies the archive checksum and the package verifies all installed payload files before installation.
