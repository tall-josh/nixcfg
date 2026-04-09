{
  description = "Josh's NixOS system";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
  };

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

      devShells.${system}.python =
        let
          pkgs = import nixpkgs { inherit system; config.allowUnfree = true; };
        in
        pkgs.mkShell {
          packages = with pkgs; [
            python313
            uv
            ruff
            pyright
            git
            direnv
          ];
        };
    };
}
