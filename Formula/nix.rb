class Nix < Formula
  desc "Purely functional package manager"
  homepage "https://nixos.org"
  url "https://github.com/aiyazmostofa/nix/releases/download/2.34.7/nix-2.34.7.tar.gz"
  sha256 "fd3503d603fd27332e29cd2f86c2477f93a097920bdd2b7653342d52602ac378"
  license "LGPL-2.1-only"

  def install
    bin.install Dir["bin/*"]
    share.install Dir["share/*"]
  end

  test do
    system bin/"nix", "--version"
  end
end
