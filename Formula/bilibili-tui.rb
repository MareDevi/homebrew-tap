class BilibiliTui < Formula
  desc "A terminal user interface (TUI) client for Bilibili"
  homepage "https://github.com/MareDevi/bilibili-tui"
  version "1.0.14"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/MareDevi/bilibili-tui/releases/download/v1.0.14/bilibili-tui-aarch64-apple-darwin.tar.xz"
    sha256 "795fd0e935406aff9c3aa31fcaf275b31b9e479764c38c80823a586619b2a62b"
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/MareDevi/bilibili-tui/releases/download/v1.0.14/bilibili-tui-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "8bb2f6fddc76abee9d6c6a65b19196f2a5bee2807a5b5555c6b85fe7367b0f5a"
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-pc-windows-gnu":    {},
    "x86_64-unknown-linux-gnu": {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "bilibili-tui"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "bilibili-tui"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
