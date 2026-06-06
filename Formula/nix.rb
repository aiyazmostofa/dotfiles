class Nix < Formula
  desc "Purely functional package manager"
  homepage "https://nixos.org"
  license "LGPL-2.1-only"

  # We are pulling from Nixpkgs via Podman, so these are undefined
  url "file:///dev/null"
  sha256 "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"
  version "latest"

  def install
    system "mkdir", "out"
    system "podman", "run", "--rm", "-v", "./out:/out:Z", "docker.io/nixos/nix", "sh", "-c", <<~EOS
      nix-channel --update
      nix-build '<nixpkgs>' -A nixStatic -o /tmp/out
      nix-build '<nixpkgs>' -A nixStatic.man -o /tmp/out
      nix-shell -p rsync --run '
        rsync -a --copy-unsafe-links /tmp/out/ /out/
        rsync -a --copy-unsafe-links /tmp/out-man/ /out/
      '
      chmod -R u+w /out
    EOS
    bin.install Dir["out/bin/*"]
    share.install Dir["out/share/*"]
  end
end
