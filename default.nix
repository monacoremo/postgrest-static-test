let
  static-haskell-nix =
    let
      rev = "acaffd5fb807aa78f106eb3b4a99b05d3a1ec043";
    in
      builtins.fetchTarball {
        url = "https://github.com/nh2/static-haskell-nix/archive/${rev}.tar.gz";
        sha256 = "1k2931w5x05yczvqkhjqd9ipgkk777215i0cjgqzkjqdzjzi08l1";
      };

  pinnedPkgs =
    let
      rev = "10100a97c8964e82b30f180fda41ade8e6f69e41";
    in
      builtins.fetchTarball {
        url = "https://github.com/nixos/nixpkgs/archive/${rev}.tar.gz";
        sha256 = "011f36kr3c1ria7rag7px26bh73d1b0xpqadd149bysf4hg17rln";
      };
in
{ compiler ? "ghc865" # Goal: "ghc883"
, integer-simple ? false # Goal: true
, defaultCabalPackageVersionComingWithGhc ? {
    ghc865 = "Cabal_2_4_1_0";
    ghc883 = "Cabal_3_2_0_0";
  }."${compiler}"
, pkgsSource ? "static-haskell-nix" # Goal: "pinned"
, pkgs ? {
    static-haskell-nix = import "${static-haskell-nix}/nixpkgs.nix";
    pinned = import pinnedPkgs {};
  }."${pkgsSource}"
}:
let
  normalPkgs =
    pkgs.appendOverlays [
      (import overlays/haskell-packages { inherit compiler integer-simple; })
    ];

  survey =
    import "${static-haskell-nix}/survey" {
      inherit normalPkgs compiler integer-simple defaultCabalPackageVersionComingWithGhc;
    };
in
{
  dynamic = normalPkgs.haskell.packages."${compiler}".postgrest;
  static = survey.haskellPackages.postgrest;
}
