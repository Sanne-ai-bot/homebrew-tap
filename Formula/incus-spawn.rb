class IncusSpawn < Formula
  desc "CLI tool for managing isolated Incus-based development environments"
  homepage "https://github.com/Sanne/incus-spawn"
  version "0.2.9"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/Sanne/incus-spawn/releases/download/v#{version}/incus-spawn-macos-aarch64"
      sha256 "5413fcf1ec3f4b0d0dad7031033a9f9c65baed266b4ddc1cbfcd584fd3ea9e6c"
    else
      odie "incus-spawn only supports Apple Silicon (arm64) on macOS"
    end
  end

  depends_on "vfkit"
  depends_on arch: :arm64

  resource "git-remote-isx" do
    url "https://github.com/Sanne/incus-spawn/releases/download/v0.2.9/git-remote-isx"
    sha256 "23dce674bcceed571f2c7760143d8bbf08aae1f903c3cf398f5256b0bf1cfa10"
  end

  def install
    bin.install "incus-spawn-macos-aarch64" => "isx"

    resource("git-remote-isx").stage do
      bin.install "git-remote-isx"
    end
  end

  def caveats
    <<~EOS
      incus-spawn has been installed as 'isx'.

      First-time setup (required):
        isx init

      This will:
        - Generate MITM CA certificate
        - Configure Claude API and GitHub credentials
        - Install VM and proxy as macOS services (auto-start at login)

      To build your first template:
        isx build tpl-java

      To launch the interactive TUI:
        isx

      Documentation: https://github.com/Sanne/incus-spawn
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/isx --version")
  end
end
