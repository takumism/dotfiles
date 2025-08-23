{
  description = "takumism's macOS dotfiles (nix-darwin + home-manager + Determinate Nix)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    # Unify the nixpkgs used by each input via `inputs.nixpkgs.follows` to keep the lock file small.
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Determinate Nix integration for nix-darwin / home-manager.
    # Note: do NOT set `inputs.nixpkgs.follows` here — it disables FlakeHub Cache hits.
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*.tar.gz";
  };

  # `self` is omitted because it is not referenced.
  outputs =
    {
      nixpkgs,
      home-manager,
      darwin,
      determinate,
      ...
    }:
    let
      username = "takumism";
      # Currently Apple Silicon only. Change to a conditional when supporting other platforms.
      system = "aarch64-darwin";

      pkgs = import nixpkgs {
        inherit system;
        # Required to allow unfree GUI apps such as Claude and Google Chrome.
        config.allowUnfree = true;
      };
    in
    {
      darwinConfigurations.${username} = darwin.lib.darwinSystem {
        inherit pkgs;
        # Propagate `username` to nix-darwin so `system.primaryUser` stays in sync.
        specialArgs = { inherit username; };
        modules = [
          determinate.darwinModules.default
          ./nix-darwin.nix
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${username} = import ./home-manager.nix;
            home-manager.sharedModules = [ determinate.homeManagerModules.default ];
          }
        ];
      };

      # Standalone home-manager entry point for `nix run home-manager -- switch`.
      homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          determinate.homeManagerModules.default
          ./home-manager.nix
        ];
      };

      # `nix fmt` formats all .nix files in the repository.
      formatter.${system} = pkgs.nixfmt-rfc-style;
    };
}
