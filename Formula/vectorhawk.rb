class Vectorhawk < Formula
  desc "Governed AI platform for skills, MCP servers, and plugins"
  homepage "https://vectorhawk.ai"
  version "1.0.4"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/vectorhawk/vectorhawkd/releases/download/v#{version}/vectorhawk-#{version}-aarch64-apple-darwin.tar.gz"
      sha256 "e69aaf48850e0cebad92602b4f200fabc7fd0b683bf1eedc2174b07bfa2771c4"
    end
    on_intel do
      url "https://github.com/vectorhawk/vectorhawkd/releases/download/v#{version}/vectorhawk-#{version}-x86_64-apple-darwin.tar.gz"
      sha256 "5341113ca43ae39d022ac158f9e842fe7bb62c6f4ec2c871deed59cff4391862"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/vectorhawk/vectorhawkd/releases/download/v#{version}/vectorhawk-#{version}-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "d770f24b1bb7797fb02d1ef3f9d88a3ef7452f9d7d07d056ccdeab6d8742d516"
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
