class CorplinkRs < Formula
  desc "使用 rust 实现的飞连客户端"
  homepage "https://github.com/PinkD/corplink-rs"
  version "5.6"
  license "GPL-2.0"

  # 只保留 macOS ARM 架构
  url "https://github.com/PinkD/corplink-rs/releases/download/#{version}/corplink-rs-#{version}-macos-arm64.tar.gz"
  sha256 "c09e524ec144d058dd34ca0ac7da14b9cd0f3bd32b3b28c65b2f048f51f8d389"

  def install
    bin.install "corplink-rs"
    (etc/"corplink-rs").mkpath
  end

  service do
    run [opt_bin/"corplink-rs", etc/"corplink-rs/config.json"]
    working_dir etc/"corplink-rs/"
    keep_alive true
    log_path var/"log/corplink-rs.log"
  end

  livecheck do
    url :stable
    strategy :github_latest
  end

  test do
    assert_match "corplink-rs", shell_output("#{bin}/corplink-rs --version")
  end
end
