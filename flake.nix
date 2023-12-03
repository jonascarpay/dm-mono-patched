{
  description = "DM Mono Patched";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    mkflake.url = "github:jonascarpay/mkflake";
    dm-mono = {
      url = "github:ylieder/dm-mono-nerd-font";
      flake = false;
    };
  };

  outputs = { nixpkgs, mkflake, dm-mono, self }: mkflake.lib.mkflake {
    perSystem = system:
      let
        pkgs = import nixpkgs { inherit system; };
        python = pkgs.python3.withPackages (p: [ p.fonttools ]);
        DM_MONO = "${dm-mono}/DMMonoNerdFont";
        SAUCECODE =
          let nerdfonts = pkgs.nerdfonts.override { fonts = [ "SourceCodePro" ]; };
          in "${nerdfonts}/share/fonts/truetype/NerdFonts";
      in
      {
        devShells.default = pkgs.mkShell {
          inherit DM_MONO SAUCECODE;
          packages = [
            pkgs.black
            pkgs.ruff
            (pkgs.python3.withPackages (p: [
              p.fonttools
              p.ipython
              p.ruff-lsp
            ]))
            pkgs.pyright
          ];
        };
        packages = rec {
          default = dm-mono-patched;
          dm-mono-patched = pkgs.stdenv.mkDerivation {
            inherit DM_MONO SAUCECODE;
            name = "dm-mono-patched";
            src = ./.;
            installPhase = "${python}/bin/python convert.py";
          };
        };
      };
  };
}
