compiler: {
  packageOverrides = pkgs: rec {
    haskellPackages = pkgs.haskell.packages.${compiler}.override {
      overrides = self: super: {
      };
    };
  };
}
