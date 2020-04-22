let
  static-haskell-nix =
    let
      rev = "bb4c1e27e391eff01591fe60830ff68a9ada41ef";
    in
      builtins.fetchTarball {
        url = "https://github.com/monacoremo/static-haskell-nix/archive/${rev}.tar.gz";
        sha256 = "15zyaii6c5pangyzz69qksg6sc6d5qzbcqxxwz0bm6gb5igpwhym";
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
, integer-simple ? true
, defaultCabalPackageVersionComingWithGhc ? {
    ghc865 = "Cabal_2_4_1_0";
    ghc883 = "Cabal_3_2_0_0";
  }."${compiler}"
, pkgsSource ? "pinned"
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
