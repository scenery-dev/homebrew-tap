class Skillrunner < Formula
  desc "Local AI skill runtime and MCP aggregator"
  homepage "https://github.com/vectorhawk/skillrunner"
  license "Apache-2.0"
  version "0.1.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/vectorhawk/skillrunner/releases/download/v0.1.0/skillrunner-aarch64-apple-darwin.tar.gz"
      sha256 "PLACEHOLDER_ARM64_SHA256"
    else
      url "https://github.com/vectorhawk/skillrunner/releases/download/v0.1.0/skillrunner-x86_64-apple-darwin.tar.gz"
      sha256 "PLACEHOLDER_X86_64_SHA256"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/vectorhawk/skillrunner/releases/download/v0.1.0/skillrunner-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "PLACEHOLDER_LINUX_ARM64_SHA256"
    else
      url "https://github.com/vectorhawk/skillrunner/releases/download/v0.1.0/skillrunner-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "PLACEHOLDER_LINUX_X86_64_SHA256"
    end
  end

  def install
    bin.install "skillrunner"
  end

  test do
    assert_match "skillrunner", shell_output("#{bin}/skillrunner --version")
  end
end
