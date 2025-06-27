# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL

{ config, lib, pkgs, ... }:

{
  # imports = [
  #   # include NixOS-WSL modules
  #   <nixos-wsl/modules>
  # ];

  environment.systemPackages = with pkgs; [
    curl
    micro
    wget
  	bat
  	zsh
  	git
    starship
    firefox
  ];
  
  # wsl configuration
  wsl.enable = true;
  wsl.defaultUser = "akio";

  # user configuration
  users.users.akio = {
  	isNormalUser = true;
  	extraGroups = [ "wheel" "networkmanager" ]; # enable "sudo" for this user
  	shell = pkgs.zsh;
  	packages = with pkgs; [
  		tree
  	];
  };

  # Zsh configuration
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    histSize = 10000;
    
    # System-wide shell aliases
    shellAliases = {
      ll = "ls -lha";
      cls = "clear";
      # nixos
      nrs = "sudo nixos-rebuild switch --flake /etc/nixos#nixos";
      nec = "sudo micro /etc/nixos/configuration.nix";
    };
    
    # oh-my-zsh integration
    ohMyZsh = {
      enable = true;
      
      # You can choose a theme here
      theme = "agnoster"; # This is the default theme
      
      # List any plugins you want to enable
      plugins = [ "git" "history" "sudo" ];
    };

    # shellInit configuration
    shellInit = ''
      # Check if the current directory is not the home directory
      if [[ "$PWD" != "$HOME" ]]; then
        cd ~ # Go to the home directory if not already there
      fi

      # init starship
      eval "$(starship init zsh)"
    '';
  };

  programs.nix-ld = {
    enable = true;
    package = pkgs.nix-ld-rs; # Use the Rust implementation for better performance
  };

  programs.starship = {
  	enable = true;
  	settings = {
  	  # other settings here
  	};
  };

  # Just leave it like this!
  system.stateVersion = "24.11";
}
