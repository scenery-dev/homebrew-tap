# VectorHawk Homebrew Tap

Homebrew formula for the VectorHawk platform.

## VectorHawk runner

Install the VectorHawk runner — a single `vectorhawk` binary that embeds the
CLI, the daemon (`vectorhawk daemon run`), and the MCP relay (`vectorhawk mcp serve`):

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
# Remove the LaunchAgent / systemd user unit if you installed it:
vectorhawk daemon uninstall
```

## Available Formulae

| Formula | Description |
|---------|-------------|
| `vectorhawk` | VectorHawk runner — pre-built `vectorhawk` binary (macOS arm64/x86_64, Linux x86_64) |
