# Goal: Build a static PostgREST 7.0.0 executable

* [x] Build dynamic executable from Hackage based on static-haskell-nix nixpkgs
  (run `nix-build -A dynamic`)
* [x] Build static executable based on static-haskell-nix defaults
  (recommended: `cachix use static-haskell-nix`; run `nix-build -A static`)
* [ ] Use integer-simple
* [ ] Switch to a newer pinned nixpkgs version
* [ ] Use a newer compiler, ghc883
* [ ] Replace the Hackage version with using callCabal2nix in the PostgREST
  respository
