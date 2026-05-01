class Vectorhawk < Formula
  desc "Governed AI platform for skills, MCP servers, and plugins"
  homepage "https://vectorhawk.ai"
  license "Apache-2.0"

  on_macos do
    on_arm do
      # TODO(D1.3 release-day): update url and fill in sha256 for aarch64-apple-darwin
      url "https://github.com/vectorhawk/vectorhawkd/releases/download/v0.1.0/vectorhawk-0.1.0-aarch64-apple-darwin.tar.gz"
      sha256 "0000000000000000000000000000000000000000000000000000000000000000"
    end
    on_intel do
      # TODO(D1.3 release-day): update url and fill in sha256 for x86_64-apple-darwin
      url "https://github.com/vectorhawk/vectorhawkd/releases/download/v0.1.0/vectorhawk-0.1.0-x86_64-apple-darwin.tar.gz"
      sha256 "0000000000000000000000000000000000000000000000000000000000000000"
    end
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
