# VectorHawk Homebrew Tap

Homebrew formula for the VectorHawk platform.

## VectorHawk runner

Install the VectorHawk runner — a single `vectorhawk` binary that embeds the
CLI, the daemon (`vectorhawk daemon run`), and the MCP relay (`vectorhawk mcp serve`):

```bash
brew tap vectorhawk/tap
brew trust vectorhawk/tap
brew install vectorhawk
```

`brew trust` is required by Homebrew 7 and later before it will load a formula
from any third-party tap. Without it `brew install` fails with
"Refusing to load formula ... from untrusted tap".

Then start the agent and configure your AI client:

```bash
brew services start vectorhawk
vectorhawk mcp setup
```

`brew services` is how the agent is started and kept running at login.
Homebrew's install sandbox cannot write to your home directory, so neither of
these can run automatically during `brew install`.

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
