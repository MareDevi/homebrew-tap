class BilibiliTui < Formula
  desc "A terminal user interface (TUI) client for Bilibili"
  homepage "https://github.com/MareDevi/bilibili-tui"
  version "1.0.12"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/MareDevi/bilibili-tui/releases/download/v1.0.12/bilibili-tui-aarch64-apple-darwin.tar.xz"
    sha256 "aac52e9fdfccf5ca1ff63e3abb6c0281ef2ac2329bba0192b3b4cff9ad463939"
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/MareDevi/bilibili-tui/releases/download/v1.0.12/bilibili-tui-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "a49baa489cd7ac7d2937663671ae735b6117395b33b8d8f7aa47184af04c640d"
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
    bin.install "bilibili-tui" if OS.mac? && Hardware::CPU.arm?
    bin.install "bilibili-tui" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
