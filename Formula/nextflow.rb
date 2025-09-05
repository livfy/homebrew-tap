class Nextflow < Formula
  desc "Reproducible scientific workflows"
  homepage "https://nextflow.io"
  url "https://github.com/nextflow-io/nextflow/archive/refs/tags/v25.04.6.tar.gz"
  sha256 "e0891da76f2e17336eaeadac14971a7e69cdc07722d44b605489c4dc6718d6a5"
  license "Apache-2.0"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://ghcr.io/v2/livfy/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c98e49a122123daf569a96a04a0e8efda1289a6112d6666ecd40aa84389f371b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "602eac405ce55832db9dda0dae0748ae016c27ba227928a1adae03a0660b52ff"
  end

  depends_on "openjdk"

  def install
    ENV["JAVA_HOME"] = Formula["openjdk"].opt_prefix

    system "make", "pack"
    bin.install "build/releases/nextflow-#{version}-dist" => "nextflow"
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
