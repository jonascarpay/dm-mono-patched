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
        SAUCECODE = "${pkgs.nerd-fonts.sauce-code-pro}/share/fonts/truetype/NerdFonts/SauceCodePro";
      in
      {
        devShells.default = pkgs.mkShell {
          inherit DM_MONO SAUCECODE;
          packages = [
            python
            pkgs.ruff
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
