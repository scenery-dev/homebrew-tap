class Vectorhawk < Formula
  desc "Governed AI platform for skills, MCP servers, and plugins"
  homepage "https://vectorhawk.ai"
  version "0.1.0-rc.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/vectorhawk/vectorhawkd/releases/download/v#{version}/vectorhawk-#{version}-aarch64-apple-darwin.tar.gz"
      sha256 "c06216243d7b71caaa8bcee3cbb5061498e8ab3689e7fae4e27a9558cabe9ffa"
    end
    # x86_64-apple-darwin (Intel) is not yet built — the GitHub free-tier
    # macos-13 runner pool was unreliable for v0.1.0-rc.0. Cross-compile
    # support from macos-14 lands before v1.0.
  end

  # Linux support is intentionally omitted -- Linux users should use:
  #   curl -fsSL https://install.vectorhawk.ai | sh
  # Homebrew on Linux is not a primary target; we may add it later.

  def install
    bin.install "vectorhawk"
    bin.install "vectorhawkd"
    bin.install "vectorhawkd-shim"
    # The bare LICENSE/README live alongside the binaries in the tarball.
    prefix.install "LICENSE"
    prefix.install "README.md" if File.exist?("README.md")
  end

  def caveats
    <<~EOS
      To enable the VectorHawk daemon at login (LaunchAgent):
        vectorhawk daemon install

      To configure your AI client:
        vectorhawk mcp setup

      Uninstall:
        brew uninstall vectorhawk
        # Then remove the LaunchAgent if you installed it:
        vectorhawk daemon uninstall
    EOS
  end

  test do
    assert_match "vectorhawk", shell_output("#{bin}/vectorhawk --version")
  end
end
