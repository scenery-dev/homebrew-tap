class Vectorhawk < Formula
  desc "Governed AI platform for skills, MCP servers, and plugins"
  homepage "https://vectorhawk.ai"
  version "1.0.20"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/vectorhawk/vectorhawkd/releases/download/v#{version}/vectorhawk-#{version}-aarch64-apple-darwin.tar.gz"
      sha256 "92f3c8b79d8de98b96ae00f0abebc3d6a513211fb5e394efb4267bdadb062394"
    end
    on_intel do
      url "https://github.com/vectorhawk/vectorhawkd/releases/download/v#{version}/vectorhawk-#{version}-x86_64-apple-darwin.tar.gz"
      sha256 "e7b5e5f2281224dcaca9f36f30a33717fe1a5324f39862187dcae06352fa60ae"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/vectorhawk/vectorhawkd/releases/download/v#{version}/vectorhawk-#{version}-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "23a1fd876d00ce11f5aaefc8f0278e2e6605eda9a6753aef8d860e03a8aa96ff"
    end
    # ARM Linux not yet built. Track demand before adding.
  end

  def install
    bin.install "vectorhawk"
    bin.install "vectorhawkd"
    bin.install "vectorhawkd-shim"
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
        1. Restart Claude Code (quit and reopen).
        2. Call the vectorhawk_login tool to authenticate.
        3. Use /skill-search or vectorhawk_search to browse available skills.

      If Claude Code was not configured automatically (e.g. install ran over
      SSH without a D-Bus session), run once in your normal login shell:
        vectorhawk mcp setup

      To uninstall cleanly:
        vectorhawk daemon uninstall
        brew uninstall vectorhawk
    EOS
  end

  test do
    assert_match "vectorhawk", shell_output("#{bin}/vectorhawk --version")
  end
end
