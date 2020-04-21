let
  pkgs =
    ...;

  static-haskell-nix =
    ...;

  survey =
    import "${static-haskell-nix}/survey"
      {
        normalPackages = pkgs;
        #compiler = "ghc883";
        #cabal...
        #integer-simple = true;
      };
in
survey.haskellPackages.postgrest
