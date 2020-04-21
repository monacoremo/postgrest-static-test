{ compiler }:

self: super:
{
  haskellPackages =
    super.haskell.packages."${compiler}".override {
      overrides =
        let
          unbreak =
            drv:
              self.haskell.lib.overrideCabal drv (drv: { broken = false; });

          dontCheck =
            self.haskell.lib.dontCheck;
        in
        newPkgs: oldPkgs: rec {
          hasql-pool = dontCheck (unbreak oldPkgs.hasql-pool);
          configurator-pg = dontCheck (unbreak oldPkgs.configurator-pg);
          postgrest = dontCheck (unbreak oldPkgs.postgrest);
        };
    };
}
