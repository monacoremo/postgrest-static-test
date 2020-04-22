# Override Haskell package for a specific compiler version and optionally
# for the integer-simple variant
{ compiler, integer-simple }:

self: super:
let
  lib =
    self.haskell.lib;

  unbreak =
    drv:
      lib.overrideCabal drv (drv: { broken = false; });

  overrides =
    final: prev:
      {
        hasql-pool = lib.dontCheck (unbreak prev.hasql-pool);
        configurator-pg = prev.callPackage ./configurator-pg.nix {};
        postgrest = lib.dontCheck (prev.callPackage ./postgrest.nix {});
        swagger2 = prev.callPackage ./swagger2.nix {};
        insert-ordered-containers = prev.callPackage ./insert-ordered-containers.nix {};

        # The tests for the packages below took a long time on static builds,
        # so I cancelled and skipped them for now - to be investigated.
        happy = lib.dontCheck prev.happy;
        data-dword = lib.dontCheck prev.data-dword;
        text-short = lib.dontCheck prev.text-short;
        jose = lib.dontCheck prev.jose;
      };
in
{
  haskell =
    super.haskell // {
      packages =
        super.haskell.packages // (
          if integer-simple
          then
            {
              integer-simple =
                super.haskell.packages.integer-simple // {
                  "${compiler}" =
                    super.haskell.packages.integer-simple."${compiler}".override
                      { inherit overrides; };
                };
            }
          else
            {
              "${compiler}" = super.haskell.packages."${compiler}".override
                { inherit overrides; };
            }
        );
    };
}
