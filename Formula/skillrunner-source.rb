class SkillrunnerSource < Formula
  desc "Local AI skill runtime and MCP aggregator (built from source)"
  homepage "https://github.com/vectorhawk/skillrunner"
  url "https://github.com/vectorhawk/skillrunner.git", tag: "v0.1.0"
  license "Apache-2.0"
  version "0.1.0"

  depends_on "rust" => :build

  def install
    system "cargo", "install",
           "--path", "crates/skillrunner-cli",
           "--root", prefix,
           "--locked"
  end

  test do
    assert_match "skillrunner", shell_output("#{bin}/skillrunner --version")
  end
end
