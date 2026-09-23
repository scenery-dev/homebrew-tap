class Vectorhawk < Formula
  desc "Governed AI platform for skills, MCP servers, and plugins"
  homepage "https://vectorhawk.ai"
  version "1.0.96"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/vectorhawk/vectorhawkd/releases/download/v#{version}/vectorhawk-#{version}-aarch64-apple-darwin.tar.gz"
      sha256 "265dbd7f08641183383e45c66accf4824a53f2d13eb512b8b7c4244180345d27"
    end
    on_intel do
      url "https://github.com/vectorhawk/vectorhawkd/releases/download/v#{version}/vectorhawk-#{version}-x86_64-apple-darwin.tar.gz"
      sha256 "2f71dc578b932b3edaae12178417dd7852480b21921a79b5b4611b3d0ecc3a0d"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/vectorhawk/vectorhawkd/releases/download/v#{version}/vectorhawk-#{version}-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "5191e4b1dbc4039d8c7fc8451acd0b04338c14c5b2f766bc4a59eb89762171ec"
    end
    # ARM Linux not yet built. Track demand before adding.
  end

  def install
    bin.install "vectorhawk"
    prefix.install "LICENSE"
    prefix.install "README.md" if File.exist?("README.md")
  end

  # Auto-start is handled by `brew services`, NOT by post_install.
  #
  # Homebrew runs post_install inside a sandbox that denies writes to the
  # user's real home on BOTH platforms -- macOS via seatbelt
  # (add_install_hook_rules grants allow_write_temp_and_cache and
  # deny_read_home, with no home write) and Linux via Landlock (a touch of a
  # user-owned file in $HOME returns EPERM).  It also points HOME, and on
  # Linux XDG_CONFIG_HOME, at a throwaway directory.  So `vectorhawk daemon
  # install` and `vectorhawk mcp setup` could never write the LaunchAgent,
  # the systemd unit, or ~/.claude.json from post_install -- they wrote into
  # the sandbox tree and it was deleted seconds later, while still reporting
  # success.  Calling them here was never going to work, so we do not.
  #
  # `brew services start vectorhawk` runs as the user, outside the sandbox,
  # and is the supported mechanism for exactly this.
  service do
    run [opt_bin/"vectorhawk", "daemon", "run", "--foreground"]
    keep_alive true
    log_path var/"log/vectorhawk.log"
    error_log_path var/"log/vectorhawk.log"
  end

  def caveats
    <<~EOS
      VectorHawk is installed. Two commands finish the setup:

        1. Start the agent (it runs at login from here on):
             brew services start vectorhawk
        2. Configure your AI clients:
             vectorhawk mcp setup

      Homebrew's install sandbox cannot write to your home directory, so these
      cannot be done for you during `brew install`.

      Then pair this device. Find the code on the portal's device setup screen
      (open the catalog page — if this device isn't registered yet, you'll see
      it there), then run and paste it when prompted:
        vectorhawk auth pair

      Restart Claude Code afterwards, then browse and install skills in the
      portal, or use the vectorhawk_search / vectorhawk_install MCP tools.

      Deploying across a fleet? Set VH_PAIR_CODE and pairing runs unattended:
        VH_PAIR_CODE=<code> vectorhawk auth pair

      Pointing at a private registry? Homebrew reads per-service environment
      from ~/.homebrew/services/vectorhawk.env (KEY=value, one per line), which
      persists across upgrades. The file must NOT be group- or world-writable
      or Homebrew skips it with a warning, so set the mode explicitly:
        mkdir -p ~/.homebrew/services
        echo 'VECTORHAWK_REGISTRY_URL=https://registry.example.com' \\
          >> ~/.homebrew/services/vectorhawk.env
        chmod 600 ~/.homebrew/services/vectorhawk.env
        brew services restart vectorhawk

      Upgrades: the agent notices its own binary changed and restarts itself
      onto the new version, so `brew upgrade` needs no follow-up.

      To uninstall cleanly:
        vectorhawk mcp remove
        brew services stop vectorhawk
        brew uninstall vectorhawk
    EOS
  end

  test do
    assert_match "vectorhawk", shell_output("#{bin}/vectorhawk --version")
  end
end
