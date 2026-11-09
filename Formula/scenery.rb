class Scenery < Formula
  desc "Governed AI platform for skills, MCP servers, and plugins"
  homepage "https://scenery.dev"
  version "2.2.1"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/scenery-dev/scenery/releases/download/v#{version}/scenery-#{version}-aarch64-apple-darwin.tar.gz"
      sha256 "0674ac47790d31f21d7311ea2f6782475e0876bb01cc38b2a0638a77b32447c1"
    end
    on_intel do
      url "https://github.com/scenery-dev/scenery/releases/download/v#{version}/scenery-#{version}-x86_64-apple-darwin.tar.gz"
      sha256 "d72e74be40f75818f8e82f0c548d7a19b1d9f34502793dd99c9661c164abd58b"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/scenery-dev/scenery/releases/download/v#{version}/scenery-#{version}-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "f27e73b25ec23fdbdfa602796f20821790392639220441fd28eaad15732655e5"
    end
    # ARM Linux not yet built. Track demand before adding.
  end

  def install
    bin.install "scenery"
    bin.install_symlink "scenery" => "scn"
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
  # Linux XDG_CONFIG_HOME, at a throwaway directory.  So `scenery daemon
  # install` and `scenery mcp setup` could never write the LaunchAgent,
  # the systemd unit, or ~/.claude.json from post_install -- they wrote into
  # the sandbox tree and it was deleted seconds later, while still reporting
  # success.  Calling them here was never going to work, so we do not.
  #
  # `brew services start scenery` runs as the user, outside the sandbox,
  # and is the supported mechanism for exactly this.
  service do
    run [opt_bin/"scenery", "daemon", "run", "--foreground"]
    keep_alive true
    log_path var/"log/scenery.log"
    error_log_path var/"log/scenery.log"
  end

  def caveats
    <<~EOS
      Scenery is installed. Two commands finish the setup:

        1. Start the agent (it runs at login from here on):
             brew services start scenery
        2. Configure your AI clients:
             scenery mcp setup

      Homebrew's install sandbox cannot write to your home directory, so these
      cannot be done for you during `brew install`.

      Then pair this device. Find the code on the portal's device setup screen
      (open the catalog page — if this device isn't registered yet, you'll see
      it there), then run and paste it when prompted:
        scenery auth pair

      Restart Claude Code afterwards, then browse and install skills in the
      portal, or use the scenery_search / scenery_install MCP tools.

      Deploying across a fleet? Set SCN_PAIR_CODE and pairing runs unattended:
        SCN_PAIR_CODE=<code> scenery auth pair

      Pointing at a private registry? Homebrew reads per-service environment
      from ~/.homebrew/services/scenery.env (KEY=value, one per line), which
      persists across upgrades. The file must NOT be group- or world-writable
      or Homebrew skips it with a warning, so set the mode explicitly:
        mkdir -p ~/.homebrew/services
        echo 'SCENERY_REGISTRY_URL=https://registry.example.com' \\
          >> ~/.homebrew/services/scenery.env
        chmod 600 ~/.homebrew/services/scenery.env
        brew services restart scenery

      Upgrades: the agent notices its own binary changed and restarts itself
      onto the new version, so `brew upgrade` needs no follow-up.

      To uninstall cleanly:
        scenery mcp remove
        brew services stop scenery
        brew uninstall scenery
    EOS
  end

  test do
    assert_match "scenery", shell_output("#{bin}/scenery --version")
  end
end
