outputs = { self, nixpkgs, ... }:
  let
    system = "x86_64-linux";
  in
  {
    packages.${system}.neovim =
      let
        pkgs = import nixpkgs { inherit system; config.allowUnfree = true; };
      in
      import ./neovim.nix pkgs;

    nixosConfigurations.luke = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        ./configuration.nix
      ];
    };
