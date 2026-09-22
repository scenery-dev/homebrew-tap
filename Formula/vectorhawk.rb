class Vectorhawk < Formula
  desc "Governed AI platform for skills, MCP servers, and plugins"
  homepage "https://vectorhawk.ai"
  version "1.0.93"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/vectorhawk/vectorhawkd/releases/download/v#{version}/vectorhawk-#{version}-aarch64-apple-darwin.tar.gz"
      sha256 "6e6e42cfad928583bf76ca2c1f04590c3ec6ba4cbddcc77ba3d56b4e8e0594cf"
    end
    on_intel do
      url "https://github.com/vectorhawk/vectorhawkd/releases/download/v#{version}/vectorhawk-#{version}-x86_64-apple-darwin.tar.gz"
      sha256 "2f07fb846577d09e93d5e5939ce1be4094a12bd3f3b313c2f2ad1aa4c338e1f8"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/vectorhawk/vectorhawkd/releases/download/v#{version}/vectorhawk-#{version}-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "12084e7bd0cadd48a81566d839ca9e867bb9028c1f9a3e7e93897f81acce56c2"
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
