class MeowRs < Formula
  desc "High-performance Rust implementation of the mihomo proxy kernel"
  homepage "https://github.com/meow-rs/meow-rs"
  version "0.29.0"
  license "MIT"

  url "https://github.com/meow-rs/meow-rs/releases/download/v#{version}/meow-v#{version}-aarch64-apple-darwin.tar.gz"
  sha256 "e5ed5ae6fa0981b5359065820d937d13f3cba5cb92a0b2533209bc120097dd08"

  depends_on :macos

  def install
    odie "meow-rs is only available for Apple Silicon macOS" unless OS.mac? && Hardware::CPU.arm?
    
    bin.install "meow", "meow-cli"
    (etc/"meow-rs").mkpath
  end

  def caveats
    <<~EOS
      The Homebrew service reads its configuration from:
        #{etc}/meow-rs/config.yaml

      Create that file before starting the service with `brew services start meow-rs`.
      The `meow-cli` command is also installed for controlling a running instance.
    EOS
  end

  service do
    run [opt_bin/"meow", "-f", etc/"meow-rs/config.yaml"]
    working_dir etc/"meow-rs"
    keep_alive true
    log_path var/"log/meow-rs.log"
    error_log_path var/"log/meow-rs-error.log"
  end

  livecheck do
    url :stable
    strategy :github_latest
  end
end
