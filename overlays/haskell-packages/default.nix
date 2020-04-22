self: super:
let
  unbreak =
    drv:
      self.haskell.lib.overrideCabal drv (drv: { broken = false; });

  dontCheck =
    self.haskell.lib.dontCheck;
in
{
  haskellPackages =
    super.haskellPackages.override {
      overrides =
        new: prev: rec {
          hasql-pool = dontCheck (unbreak prev.hasql-pool);
          configurator-pg = prev.callPackage ./configurator-pg.nix {};
          postgrest = dontCheck (prev.callPackage ./postgrest.nix {});
          swagger2 = prev.callPackage ./swagger2.nix {};
          insert-ordered-containers = prev.callPackage ./insert-ordered-containers.nix {};
        };
    };
}
