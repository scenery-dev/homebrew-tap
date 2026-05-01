# VectorHawk Homebrew Tap

Homebrew formulae for the VectorHawk platform.

## VectorHawk runner

Install the VectorHawk runner (includes `vectorhawk`, `vectorhawkd`, and `vectorhawkd-shim`):

```bash
brew tap vectorhawk/tap
brew install vectorhawk
```

Then provision the daemon and configure your AI client:

```bash
vectorhawk daemon install
vectorhawk mcp setup
```

### Upgrade

```bash
brew upgrade vectorhawk
```

### Uninstall

```bash
brew uninstall vectorhawk
# Remove the LaunchAgent if you installed it:
vectorhawk daemon uninstall
```

---

## Legacy: SkillRunner (deprecated, not yet removed)

The following formulae are the predecessor to VectorHawk and will be removed in a future cleanup commit.

### Install SkillRunner

```bash
brew install vectorhawk/tap/skillrunner
```

### Upgrade

```bash
brew upgrade skillrunner
```

### Build from source

If you prefer to compile from source (requires Rust 1.75+):

```bash
brew install vectorhawk/tap/skillrunner-source
```

## Available Formulae

| Formula | Description |
|---------|-------------|
| `vectorhawk` | VectorHawk runner -- pre-built binary (macOS arm64/x86_64) |
| `skillrunner` | Pre-built binary (macOS arm64/x86_64, Linux x86_64/arm64) -- legacy |
| `skillrunner-source` | Built from source (requires Rust toolchain) -- legacy |
