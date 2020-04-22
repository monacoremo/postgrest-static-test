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
        # The tests for the packages below took a long time on static builds,
        # so I cancelled and skipped them for now - to be investigated.
        happy = lib.dontCheck prev.happy;
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
