{ compiler }:
let
  unbreak =
    drv:
      ...;
in
self: super:
{
  haskellPackages =
    super.haskell.packages."${compiler}".override {
      overrides =
        with self.haskell.lib;
        newPkgs: oldPkgs: rec {
          hasql-pool = dontCheck (unbreak oldPkgs.hasql-pool);
          configurator-pg = dontCheck (unbreak oldPkgs.configurator-pg);
          postgrest = dontCheck (unbreak oldPkgs.postgrest);
        };
    };
}
