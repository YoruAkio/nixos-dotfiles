# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

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
  ];
  
  # wsl configuration
  wsl.enable = true;
  wsl.defaultUser = "akio";

  # user configuration
  users.users.akio = {
  	isNormalUser = true;
  	extraGroups = [ "whell" "networkmanager" ]; # enable "sudo" for this user
  	shell = pkgs.zsh;
  	packages = with pkgs; [
  		tree
  	];
  };

  # zsh configuration
  # Zsh configuration
  programs.zsh = {
    enable = true;
    # oh-my-zsh integration
    ohMyZsh = {
      enable = true;
      
      # You can choose a theme here
      theme = "agnoster"; # This is the default theme
      
      # List any plugins you want to enable
      plugins = [ "git" "history" "sudo"];
    };
    
    # Set the default shell for new terminals to zsh
    enableCompletion = true;
    syntaxHighlighting.enable = true;
	histSize = 10000;

    # aliases
#     shellAliases = {
#       ll = "ls -lha";
#       cls = "clear";
# 	        
# 
#       # nixos
#       nrs = "sudo nixos-rebuild switch --flake /etc/nixos#nixos";
#       nec = "sudo micro /etc/nixos/configuration.nix";
#     };

    # prezsh configuration
    shellInit = ''
	  # Check if the current directory is not the home directory
	  if [[ "$PWD" != "$HOME" ]]; then
	    # Check if we are in a known Windows path from a Windows-launched terminal
	    if [[ "$PWD" == "/mnt/c/Users/ether" ]]; then
	      # Go to the home directory of the user
	      cd ~
	    fi
	    # You can add more checks here for other directories if needed
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

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
