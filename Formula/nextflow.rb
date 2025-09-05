class Nextflow < Formula
  desc "Reproducible scientific workflows"
  homepage "https://nextflow.io"
  url "https://github.com/nextflow-io/nextflow/archive/refs/tags/v25.04.6.tar.gz"
  sha256 "e0891da76f2e17336eaeadac14971a7e69cdc07722d44b605489c4dc6718d6a5"
  license "Apache-2.0"
  revision 2

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://ghcr.io/v2/livfy/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "33e7507b81a69c30893a3818a2eaa1852b9950651bee069c43b55428b06156b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "83a8b237ec122b6a916e91fc99a0fadd4a82d576fe80601421ba64ea18508746"
  end

  depends_on "openjdk"

  def install
    system "make", "pack"
    bin.install "build/releases/nextflow-#{version}-dist" => "nextflow"
  end

  test do
    ENV["JAVA_HOME"] = Formula["openjdk"].opt_prefix

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
