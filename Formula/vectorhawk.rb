class Vectorhawk < Formula
  desc "Governed AI platform for skills, MCP servers, and plugins"
  homepage "https://vectorhawk.ai"
  version "1.0.92"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/vectorhawk/vectorhawkd/releases/download/v#{version}/vectorhawk-#{version}-aarch64-apple-darwin.tar.gz"
      sha256 "46e1ce398ffae75a571c3d44479ea6a26e52adb9a58bead92188a7e465801bb6"
    end
    on_intel do
      url "https://github.com/vectorhawk/vectorhawkd/releases/download/v#{version}/vectorhawk-#{version}-x86_64-apple-darwin.tar.gz"
      sha256 "5a405906962b70efb898c1b7acc65652f3be4109a26ad094813313301199a5ad"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/vectorhawk/vectorhawkd/releases/download/v#{version}/vectorhawk-#{version}-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "07beaf9b62ed7c637cdf5e6dd93a2da329955691f8f1386c711a1d49c26caace"
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
    # Linux).  On Linux the Homebrew sandbox may not have an active D-Bus
    # session, so systemctl --user calls fail with "No medium found".  Both
    # daemon install and mcp setup can trigger this; both are non-fatal because
    # the systemd unit file is still written and will activate on next login.
    system "/bin/sh", "-c", "#{bin}/vectorhawk daemon install || true"
    system "/bin/sh", "-c", "#{bin}/vectorhawk mcp setup || true"
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
