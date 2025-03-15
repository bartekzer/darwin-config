{
  nixConfig = {
    substituers = [
      "https://cache.nixos.org"
    ];
  };

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    };
    darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs = {
        nixpkgs = {
          follows = "nixpkgs";
        };
      };
    };
    nix-homebrew = {
      url = "github:zhaofengli-wip/nix-homebrew";
    };
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs = {
        nixpkgs = {
          follows = "nixpkgs";
        };
      };
    };
    vide = {
      url = "github:bartekzer/vide";
      inputs = {
        nixpkgs = {
          follows = "nixpkgs";
        };
      };
    };
    lrk = {
      url = "github:bartekzer/lrk";
      inputs = {
        nixpkgs = {
          follows = "nixpkgs";
        };
      };
    };
  };

  outputs = inputs @ {
    self,
    darwin,
    nixpkgs,
    home-manager,
    nix-homebrew,
    homebrew-core,
    homebrew-cask,
    homebrew-bundle,
    ...
  }: let
    system = "aarch64-darwin";
    username = "lucas";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
    specialArgs = {inherit inputs pkgs username;};
  in {
    formatter.${system} = pkgs.alejandra;
    darwinConfigurations = {
      mac = darwin.lib.darwinSystem {
        inherit system specialArgs;
        modules = [
          ./modules

          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = specialArgs;
            home-manager.users.${username} = import ./home;
          }

          nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew = {
              enable = true;
              user = username;

              taps = {
                "homebrew/homebrew-core" = homebrew-core;
                "homebrew/homebrew-cask" = homebrew-cask;
                "homebrew/homebrew-bundle" = homebrew-bundle;
              };

              mutableTaps = false;
            };
          }
        ];
      };
    };
  };
}
