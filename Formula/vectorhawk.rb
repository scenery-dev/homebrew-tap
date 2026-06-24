class Vectorhawk < Formula
  desc "Governed AI platform for skills, MCP servers, and plugins"
  homepage "https://vectorhawk.ai"
  version "1.0.75"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/vectorhawk/vectorhawkd/releases/download/v#{version}/vectorhawk-#{version}-aarch64-apple-darwin.tar.gz"
      sha256 "a5baec82e7dadb9ca82552db6a3d99391de8d8a333d10faa292a5f0430cabe71"
    end
    on_intel do
      url "https://github.com/vectorhawk/vectorhawkd/releases/download/v#{version}/vectorhawk-#{version}-x86_64-apple-darwin.tar.gz"
      sha256 "cb2e13d21c177b0f70f160d283ab46dac3c489d4176f23df14d01a1dd206bd7d"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/vectorhawk/vectorhawkd/releases/download/v#{version}/vectorhawk-#{version}-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "e598e07b3225872e3e89e8b5484b8532f1c8e7df1e7daf689ec33b2e488bb267"
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
        1. Restart Claude Code (quit and reopen).
        2. Call the vectorhawk_login tool to authenticate.
        3. Browse and install skills in the portal, or use the vectorhawk_search
           / vectorhawk_install MCP tools. Installed skills appear as usual in
           Claude Code's skills list.

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
