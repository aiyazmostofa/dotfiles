class Emacs < Formula
  desc "Great OS, just needs a good text editor"
  homepage "https://www.gnu.org/software/emacs"
  url "https://ftpmirror.gnu.org/emacs/emacs-30.2.tar.xz"
  sha256 "b3f36f18a6dd2715713370166257de2fae01f9d38cfe878ced9b1e6ded5befd9"
  license "GPL-3.0-or-later"

  depends_on "make" => :build
  depends_on "pkgconf" => :build

  depends_on "attr"
  depends_on "glibc"
  depends_on "gnutls"
  depends_on "gtk+3"
  depends_on "libselinux"
  depends_on "tree-sitter@0.25"

  def install
    args = std_configure_args + %w[
      --with-pgtk
      --with-tree-sitter
    ]

    # Hack to make this build on immutable distros (where /home -> /var/home)
    ENV["HOMEBREW_PREFIX"] = HOMEBREW_PREFIX.realpath

    system "./configure", *args
    system "make", "install"

    # Remove files that conflict with other Brew things
    rm share/"glib-2.0/schemas/gschemas.compiled"
  end
end
