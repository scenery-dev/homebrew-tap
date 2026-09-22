require "etc"

class Vectorhawk < Formula
  desc "Governed AI platform for skills, MCP servers, and plugins"
  homepage "https://vectorhawk.ai"
  version "1.0.94"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/vectorhawk/vectorhawkd/releases/download/v#{version}/vectorhawk-#{version}-aarch64-apple-darwin.tar.gz"
      sha256 "7bc08d117b7b8dc8dec49df35c738d2a6d7b699e75c86a773979bf316110ab97"
    end
    on_intel do
      url "https://github.com/vectorhawk/vectorhawkd/releases/download/v#{version}/vectorhawk-#{version}-x86_64-apple-darwin.tar.gz"
      sha256 "98e28ace8795a4f5e41eb761079abc0de38a29bc38554f1e114cbf7537f590dd"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/vectorhawk/vectorhawkd/releases/download/v#{version}/vectorhawk-#{version}-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "d9ebac39ddd211430f81c0317666295f7f396d7bf6743deaabb60cbdf866af53"
    end
    # ARM Linux not yet built. Track demand before adding.
  end

  def install
    bin.install "vectorhawk"
    prefix.install "LICENSE"
    prefix.install "README.md" if File.exist?("README.md")
  end

  def post_install
    # Install the login-time daemon (LaunchAgent on macOS, systemd user unit on
    # Linux) and wire up the MCP client config.
    #
    # Homebrew runs post_install with HOME pointed at a throwaway sandbox
    # directory (e.g. /var/tmp/s-XXXXXXXX/vectorhawk-postinstall-.../).  Both
    # installers resolve their unit path from HOME -- dirs::config_dir() on
    # Linux, dirs::home_dir() on macOS -- so without this override the unit was
    # written into that temp tree and deleted seconds later, while the install
    # still reported success (systemctl --user keys off XDG_RUNTIME_DIR rather
    # than HOME, so it happily started whatever unit already existed).  The net
    # effect was that brew never actually installed a working auto-start unit.
    #
    # Etc.getpwuid gives the invoking user's real home from the passwd
    # database, which the sandbox does not rewrite.  As of 1.0.94 the CLI also
    # refuses to install into a mismatched HOME rather than reporting a success
    # it cannot deliver, so a regression here fails loudly instead of silently.
    real_home = Etc.getpwuid(Process.uid).dir

    with_env(HOME: real_home) do
      system "/bin/sh", "-c", "#{bin}/vectorhawk daemon install || true"
      system "/bin/sh", "-c", "#{bin}/vectorhawk mcp setup || true"
    end
  end

  def caveats
    <<~EOS
      VectorHawk is ready.

      Next steps:
        1. Pair this device. Find the code on the portal's device setup screen
           (open the catalog page — if this device isn't registered yet, you'll
           see it there), then run and paste it when prompted:
             vectorhawk auth pair
        2. Restart Claude Code (quit and reopen).
        3. Browse and install skills in the portal, or use the vectorhawk_search
           / vectorhawk_install MCP tools. Installed skills appear as usual in
           Claude Code's skills list.

      Deploying across a fleet? Set VH_PAIR_CODE and pairing runs unattended:
        VH_PAIR_CODE=<code> vectorhawk auth pair

      If Claude Code was not configured automatically (e.g. install ran over
      SSH without a D-Bus session), run once in your normal login shell:
        vectorhawk mcp setup

      To uninstall cleanly:
        vectorhawk mcp remove
        vectorhawk daemon uninstall
        brew uninstall vectorhawk
    EOS
  end

  test do
    assert_match "vectorhawk", shell_output("#{bin}/vectorhawk --version")
  end
end
