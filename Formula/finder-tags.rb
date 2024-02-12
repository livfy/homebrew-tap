class FinderTags < Formula
  desc "Command-line tool for managing finder tags on macOS"
  homepage "https://github.com/livfi/finder-tags"
  url "https://github.com/livfi/finder-tags.git",
    tag:      "v0.1.0",
    revision: "d18256e1cfb24f6ca3c394b92041a4a59d2047b2"
  license "MIT"
  head "https://github.com/livfi/finder-tags.git", branch: "main"

  pour_bottle? only_if: :clt_installed

  depends_on xcode: ["15.0.1", :build]
  depends_on :macos
  uses_from_macos "swift"

  def install
    # https://rubydoc.brew.sh/Formula.html#std_configure_args-instance_method
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/tag"
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! For Homebrew/homebrew-core
    # this will need to be a test that verifies the functionality of the
    # software. Run the test with `brew test finder-tags`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    test_tag = "Purple"
    test_file = Pathname.pwd + "test_file"
    touch test_file
    system "#{bin}/tag", "add", "-t", test_tag, "-p", test_file
    assert_equal test_tag, `#{bin}/tag list -p #{test_file}`.chomp
  end
end
