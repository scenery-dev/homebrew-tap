# Scenery Homebrew Tap

Homebrew formula for the Scenery platform.

## Scenery runner

Install the Scenery runner — a single `scenery` binary (with a short `scn` alias)
that embeds the CLI, the daemon (`scenery daemon run`), and the MCP relay
(`scenery mcp serve`):

```bash
brew tap scenery-dev/tap
brew trust scenery-dev/tap
brew install scenery
```

`brew trust` is required by Homebrew 7 and later before it will load a formula
from any third-party tap. Without it `brew install` fails with
"Refusing to load formula ... from untrusted tap".

Then start the agent and configure your AI client:

```bash
brew services start scenery
scenery mcp setup
```

`brew services` is how the agent is started and kept running at login.
Homebrew's install sandbox cannot write to your home directory, so neither of
these can run automatically during `brew install`.

### Upgrade

```bash
brew upgrade scenery
```

### Uninstall

```bash
brew uninstall scenery
# Remove the LaunchAgent / systemd user unit if you installed it:
scenery daemon uninstall
```

## Available Formulae

| Formula | Description |
|---------|-------------|
| `scenery` | Scenery runner — pre-built `scenery` binary plus `scn` alias (macOS arm64/x86_64, Linux x86_64) |
