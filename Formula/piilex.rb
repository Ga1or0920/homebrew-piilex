# typed: false
# frozen_string_literal: true

class Piilex < Formula
  desc "PII Lexical Analyzer -- Detect PII in source code and map to regulatory frameworks"
  homepage "https://github.com/Ga1or0920/piilex"
  version "0.2.0"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/Ga1or0920/piilex/releases/download/v#{version}/piilex-v#{version}-aarch64-apple-darwin.tar.gz"
      sha256 "d2696c5b9074c76b1b5948d32703f0370b492305c61118ca08423f366d831599"
    else
      url "https://github.com/Ga1or0920/piilex/releases/download/v#{version}/piilex-v#{version}-x86_64-apple-darwin.tar.gz"
      sha256 "fed9e3468a7ea0016c7b965fc25d44cb3540a1980dab091f0c7c60f5dec3aa66"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/Ga1or0920/piilex/releases/download/v#{version}/piilex-v#{version}-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "5b0112689d9c21956b014fcc019ec706a07b4f07acf88e2c5cffde794121fb64"
    else
      url "https://github.com/Ga1or0920/piilex/releases/download/v#{version}/piilex-v#{version}-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "81d16f2c8c9d011cb51c39efc5d6c322595878c449b88ff97257c4ae155b624a"
    end
  end

  def install
    bin.install "piilex"
  end

  test do
    assert_match "piilex #{version}", shell_output("#{bin}/piilex --version")

    (testpath/"test.ts").write <<~EOS
      const email = "user@example.com";
      const count = 42;
    EOS
    output = shell_output("#{bin}/piilex scan #{testpath}/test.ts -o json")
    assert_match '"pii_type"', output

    (testpath/"clean.ts").write <<~EOS
      const total = 100;
      function add(a: number, b: number) { return a + b; }
    EOS
    clean_output = shell_output("#{bin}/piilex scan #{testpath}/clean.ts -o json")
    assert_match '"findings": []', clean_output

    system "#{bin}/piilex", "init"
    assert_predicate testpath/".piilex.yml", :exist?
  end
end
