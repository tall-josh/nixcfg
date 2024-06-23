{
  description = "my computers in flakes";
  inputs.nixpkgs.url = "github:nixos/nixpkgs/master";
  #inputs.nixtheplanet.url = "github:matthewcroughan/nixtheplanet";
  outputs =
    {
      self,
      nixpkgs,
      #nixtheplanet,
    }:
    {
      packages.x86_64-linux.neovim = import ./neovim.nix (import nixpkgs { system = "x86_64-linux"; });
    };
}
