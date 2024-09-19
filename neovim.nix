pkgs: pkgs.wrapNeovim pkgs.neovim-unwrapped {

  configure = {

    buildInputs = with pkgs; [
        ruff-lsp
        nodePackages.pyright
    ];

    customRC = ''
      lua << EOF
      ${builtins.readFile ./init.lua}
      EOF
      let g:rooter_patterns = ['.git']
    '';
    packages.myVimPackage = with pkgs.vimPlugins; {
      start = [
        telescope-nvim
        plenary-nvim
        vim-rooter
        rose-pine
        #nvim-treesitter.withAllGrammars
	    (nvim-treesitter.withPlugins (p: [ p.c p.java p.python p.json p.yaml p.toml p.lua p.nix ]))
        vim-fugitive
	    #lsp-zero-nvim
        nvim-lspconfig
        cmp-nvim-lsp
        cmp-buffer
        cmp-path
        cmp-cmdline
        nvim-cmp
        cmp-nvim-lua
        luasnip
        friendly-snippets
        cmp_luasnip
        nerdtree
      ];
    };
  };
}

