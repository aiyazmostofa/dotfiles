class Emacs < Formula
  desc "Great OS, just needs a good text editor"
  homepage "https://www.gnu.org/software/emacs"
  url "https://ftpmirror.gnu.org/emacs/emacs-30.2.tar.xz"
  sha256 "b3f36f18a6dd2715713370166257de2fae01f9d38cfe878ced9b1e6ded5befd9"
  license "GPL-3.0-or-later"

  depends_on "make" => :build
  depends_on "pkgconf" => :build

  depends_on "attr"
  depends_on "gcc@15"
  depends_on "glibc"
  depends_on "gnutls"
  depends_on "gtk+3"
  depends_on "libgccjit"
  depends_on "libselinux"
  depends_on "tree-sitter@0.25"

  def install
    args = std_configure_args + %w[
      --with-pgtk
      --with-tree-sitter
      --with-native-compilation
    ]

    # Libgccjit is a special library that isn't in pkgconf
    libgccjit = Formula["libgccjit"]
    ENV.append "LDFLAGS", "-L#{libgccjit.opt_lib}/gcc/current"
    ENV.append "LDFLAGS", "-Wl,-rpath,#{libgccjit.opt_lib}/gcc/current"
    ENV.prepend_path "LIBRARY_PATH", "#{libgccjit.opt_lib}/gcc/current"
    ENV.prepend_path "CPATH", libgccjit.opt_include

    # Ensure that the right version of Tree-sitter is used
    tree_sitter = Formula["tree-sitter@0.25"]
    ENV.append "LDFLAGS", "-L#{tree_sitter.opt_lib}"
    ENV.append "LDFLAGS", "-Wl,-rpath,#{tree_sitter.opt_lib}"
    ENV.prepend_path "LIBRARY_PATH", tree_sitter.opt_lib
    ENV.prepend_path "CPATH", tree_sitter.opt_include

    # Hack to make this build on immutable distros (where /home -> /var/home)
    ENV["HOMEBREW_PREFIX"] = HOMEBREW_PREFIX.realpath

    system "./configure", *args
    system "make", "install"

    # Remove files that conflict with other Brew things
    rm share/"glib-2.0/schemas/gschemas.compiled"

    # Add libgcc to libgccjit driver flags
    gcc = Formula["gcc@15"]
    (share/"emacs/site-lisp/site-start.el").write <<~EOS
      (setq native-comp-driver-options
            '("-L#{gcc.opt_lib}/gcc/current"
              "-L#{gcc.opt_lib}/gcc/current/gcc/x86_64-pc-linux-gnu/15"))
    EOS
  end
end
