{
  pkgs,
  inputs,
  username,
  ...
}: {
  imports = [
    ./core.nix
    ./softwares
  ];

  home = {
    inherit username;
    homeDirectory = "/Users/${username}";
    stateVersion = "25.05";
  };

  programs = {
    home-manager = {
      enable = true;
    };
  };
}
