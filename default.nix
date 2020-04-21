let
  nixpkgsVersion =
    {
      date = "2020-04-19";
      rev = "10100a97c8964e82b30f180fda41ade8e6f69e41";
      tarballHash = "011f36kr3c1ria7rag7px26bh73d1b0xpqadd149bysf4hg17rln";
    };

  pinnedPkgs =
    builtins.fetchTarball {
      url = "https://github.com/nixos/nixpkgs/archive/${nixpkgsVersion.rev}.tar.gz";
      sha256 = nixpkgsVersion.tarballHash;
    };

  pkgs =
    import pinnedPkgs {};

  static-haskell-nix =
    fetchTarball https://github.com/nh2/static-haskell-nix/archive/d1b20f35ec7d3761e59bd323bbe0cca23b3dfc82.tar.gz;

  survey =
    import "${static-haskell-nix}/survey"
      {
        normalPackages = pkgs;
        #compiler = "ghc883";
        #defaultCabalPackageVersionComingWithGhc = "Cabal_3_2_0_0";
        #integer-simple = true;
      };
in
survey.haskellPackages.postgrest
