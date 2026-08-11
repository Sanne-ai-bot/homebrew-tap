class IncusSpawnDev < Formula
  desc "CLI tool for managing isolated Incus-based development environments (dev channel)"
  homepage "https://github.com/Sanne/incus-spawn"
  version "0.2.21-dev.6"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/Sanne/incus-spawn/releases/download/v#{version}/incus-spawn-macos-aarch64"
      sha256 "6496275d074eaac529911aab03cde0a67ecfe49f546ac8b00d86612c6344dd87"
    else
      url "https://github.com/Sanne/incus-spawn/releases/download/v#{version}/incus-spawn-macos-x86_64"
      sha256 "b77b8f3654095a764229b7259c073baad98cf20a6c89ae84ed7c81d44f73a82b"
    end
  end

  depends_on "vfkit"

  conflicts_with "incus-spawn", because: "both install the `isx` binary"

  resource "isx-proxy" do
    on_macos do
      on_arm do
        url "https://github.com/Sanne/incus-spawn/releases/download/v0.2.21-dev.6/isx-proxy-macos-aarch64"
        sha256 "887cf5c06f6fd3084735d4cd63be35fc4643161c1446056bf528541972cb2912"
      end
      on_intel do
        url "https://github.com/Sanne/incus-spawn/releases/download/v0.2.21-dev.6/isx-proxy-macos-x86_64"
        sha256 "7844933f2dc4908a4bae65e2b9961594dca6249d845a6481b4f445ac564602b7"
      end
    end
  end

  resource "git-remote-isx" do
    url "https://github.com/Sanne/incus-spawn/releases/download/v0.2.21-dev.6/git-remote-isx"
    sha256 "23dce674bcceed571f2c7760143d8bbf08aae1f903c3cf398f5256b0bf1cfa10"
  end

  resource "completions" do
    url "https://github.com/Sanne/incus-spawn/releases/download/v0.2.21-dev.6/completions.tar.gz"
    sha256 "affa4f4e519d450f43e5da43e4c4d70a134bfaccfeb7ac5f1277752cc5623cb6"
  end

  def install
    if Hardware::CPU.arm?
      bin.install "incus-spawn-macos-aarch64" => "isx"
    else
      bin.install "incus-spawn-macos-x86_64" => "isx"
    end

    resource("isx-proxy").stage do
      if Hardware::CPU.arm?
        bin.install "isx-proxy-macos-aarch64" => "isx-proxy"
      else
        bin.install "isx-proxy-macos-x86_64" => "isx-proxy"
      end
    end

    resource("git-remote-isx").stage do
      bin.install "git-remote-isx"
    end

    resource("completions").stage do
      bash_completion.install "isx.bash" => "isx"
      zsh_completion.install "_isx"
      fish_completion.install "isx.fish"
    end
  end

  def caveats
    <<~EOS
      incus-spawn (dev) has been installed as 'isx'.

      This is the development channel — expect frequent updates.
      For the stable release, use: brew install Sanne/tap/incus-spawn

      First-time setup (required):
        isx init

      Documentation: https://github.com/Sanne/incus-spawn
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/isx --version")
  end
end
