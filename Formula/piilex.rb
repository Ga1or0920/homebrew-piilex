# typed: false
# frozen_string_literal: true

# Formula automatically updated by release workflow.
# Manual edits will be overwritten on next release.
class Piilex < Formula
  desc "PII Lexical Analyzer -- Detect PII in source code and map to regulatory frameworks"
  homepage "https://github.com/piilex/piilex"
  version "0.1.0"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/piilex/piilex/releases/download/v#{version}/piilex-v#{version}-aarch64-apple-darwin.tar.gz"
      sha256 "PLACEHOLDER_SHA256_MACOS_ARM64"
    else
      url "https://github.com/piilex/piilex/releases/download/v#{version}/piilex-v#{version}-x86_64-apple-darwin.tar.gz"
      sha256 "PLACEHOLDER_SHA256_MACOS_X86_64"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/piilex/piilex/releases/download/v#{version}/piilex-v#{version}-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "PLACEHOLDER_SHA256_LINUX_ARM64"
    else
      url "https://github.com/piilex/piilex/releases/download/v#{version}/piilex-v#{version}-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "PLACEHOLDER_SHA256_LINUX_X86_64"
    end
  end

  def install
    bin.install "piilex"
  end

  test do
    # Verify binary runs
    assert_match "piilex #{version}", shell_output("#{bin}/piilex --version")

    # Verify scan works on a simple file
    (testpath/"test.ts").write <<~EOS
      const email = "user@example.com";
      const count = 42;
    EOS
    output = shell_output("#{bin}/piilex scan #{testpath}/test.ts -o json")
    assert_match '"pii_type"', output

    # Verify clean file has no findings
    (testpath/"clean.ts").write <<~EOS
      const total = 100;
      function add(a: number, b: number) { return a + b; }
    EOS
    clean_output = shell_output("#{bin}/piilex scan #{testpath}/clean.ts -o json")
    assert_match '"findings": []', clean_output

    # Verify init creates config
    system "#{bin}/piilex", "init"
    assert_predicate testpath/".piilex.yml", :exist?
  end
end
