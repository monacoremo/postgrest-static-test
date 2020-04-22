# Override Haskell package for a specific compiler version and optionally
# for the integer-simple variant
{ compiler, integer-simple }:

self: super:
let
  unbreak =
    drv:
      self.haskell.lib.overrideCabal drv (drv: { broken = false; });

  dontCheck =
    self.haskell.lib.dontCheck;

  overrides =
    new: prev:
      {
        hasql-pool = dontCheck (unbreak prev.hasql-pool);
        configurator-pg = prev.callPackage ./configurator-pg.nix {};
        postgrest = dontCheck (prev.callPackage ./postgrest.nix {});
        swagger2 = prev.callPackage ./swagger2.nix {};
        insert-ordered-containers = prev.callPackage ./insert-ordered-containers.nix {};
      };
in
if integer-simple
then
  # Need to override pkgs.haskell.packages.integer-simple."${compiler}"
  {
    haskell =
      super.haskell // {
        packages =
          super.haskell.packages // {
            integer-simple =
              super.haskell.packages.integer-simple // {
                "${compiler}" =
                  super.haskell.packages.integer-simple."${compiler}".override
                    { inherit overrides; };
              };
          };
      };
  }
  else
  # Need to override pkgs.haskell.packages."${compiler}"
  {
    haskell =
      super.haskell // {
        packages =
          super.haskell.packages // {
            "${compiler}" = super.haskell.packages."${compiler}".override
              { inherit overrides; };
          };
      };
  }
