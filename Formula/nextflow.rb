class Nextflow < Formula
  desc "Reproducible scientific workflows"
  homepage "https://nextflow.io"
  url "https://github.com/nextflow-io/nextflow/archive/refs/tags/v25.04.5.tar.gz"
  sha256 "97eb43ef18db890790eb0646091acfd814f49ce233ad48453c1c57682f860bb3"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://ghcr.io/v2/livfy/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b7fb7f3a60d7cd27d5169669728e87c754b33cdf80a4892d57c9e20d65fce93f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b4a241b2b13a2cbfd810d8105e6972d838a2416910ac442f554659645f2ca220"
  end

  depends_on "openjdk"

  def install
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
