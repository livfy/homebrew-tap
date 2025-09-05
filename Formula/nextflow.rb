class Nextflow < Formula
  desc "Reproducible scientific workflows"
  homepage "https://nextflow.io"
  url "https://github.com/nextflow-io/nextflow/archive/refs/tags/v25.04.6.tar.gz"
  sha256 "e0891da76f2e17336eaeadac14971a7e69cdc07722d44b605489c4dc6718d6a5"
  license "Apache-2.0"
  revision 3

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://ghcr.io/v2/livfy/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e71d20143daa29058d5e4e82104e0adbbede802fda20a987f657edeb7af1ea30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7cccba723a7c09c9f5b76b179dcfc0a9eb2ade7586917ad4f5a6b5896fd38253"
  end

  depends_on "openjdk"

  def install
    system "make", "pack"
    libexec.install "build/releases/nextflow-#{version}-dist" => "nextflow"

    (bin/"nextflow").write_env_script libexec/"nextflow", Language::Java.overridable_java_home_env
  end

  test do
    (testpath/"hello.nf").write <<~EOS
      process hello {
        publishDir "results", mode: "copy"

        output:
        path "hello.txt"

        script:
        """
        echo 'Hello!' > hello.txt
        """
      }
      workflow {
        hello()
      }
    EOS

    system bin/"nextflow", "run", "hello.nf"

    assert_path_exists testpath/"results/hello.txt"
  end
end
