class Vectorhawk < Formula
  desc "Governed AI platform for skills, MCP servers, and plugins"
  homepage "https://vectorhawk.ai"
  version "1.0.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/vectorhawk/vectorhawkd/releases/download/v#{version}/vectorhawk-#{version}-aarch64-apple-darwin.tar.gz"
      sha256 "7c77c3661c5a2383906c2ca6436094703d46fd705d65b17df12eb08073516904"
    end
    # x86_64-apple-darwin (Intel) deferred — cross-compile from macos-14
    # is the planned approach (free-tier macos-13 runner pool is unreliable).
  end

  on_linux do
    on_intel do
      url "https://github.com/vectorhawk/vectorhawkd/releases/download/v#{version}/vectorhawk-#{version}-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "2b6b4da73ae3ce58a55e81a924caa8ec5ea146b01bf1a95dc66b2a79dbb2ab2a"
    end
    # ARM Linux not yet built. Track demand before adding.
  end

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
