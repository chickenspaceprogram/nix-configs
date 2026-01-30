# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

let
  home-manager = builtins.fetchTarball https://github.com/nix-community/home-manager/archive/release-25.11.tar.gz;
in
{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./apple-silicon-support
    (import "${home-manager}/nixos")
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;
  boot.binfmt.emulatedSystems = [
#    "armv7l-linux"
#    "i386-linux"
    "x86_64-linux"
  ];

  documentation = {
    dev.enable = true;
    man.generateCaches = true;
    info.enable = true;
    nixos.includeAllModules = true;
  };
  fonts = {
  	enableDefaultPackages = true;
	packages = builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);
	enableGhostscriptFonts = true;
  };
  nix = {
    settings.auto-optimise-store = true;
    gc = {
      automatic = true;
      persistent = true;
      dates = "2day";
      options = "--delete-older-than +5";
    };
  };

  #swapDevices = [ {
  #  device = "/var/lib/swapfile";
  #  size = 8*1024;
  #} ];
  
  systemd.tmpfiles.rules = [ "L+ /var/lib/qemu/firmware - - - - ${pkgs.qemu}/share/qemu/firmware" ];

  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "US/Pacific";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.

  i18n = {
    supportedLocales = [
      "en_US.UTF-8/UTF-8"
      "en_DK.UTF-8/UTF-8"
    ];

    extraLocaleSettings = {
      LC_MESSAGES = "en_US.UTF-8";
      LC_TIME = "en_DK.UTF-8";
    };
  };

  #console = {
  #  font = "Lat2-Terminus16";
  #  keyMap = "us";
  #  useXkbConfig = true; # use xkb.options in tty.
  #};

  # Enable the X11 windowing system.
  # services.xserver.enable = true;


  
  services = {
    # Enable CUPS to print documents.
    printing.enable = true;
    flatpak.enable = true;
    # Enable sound.
    pipewire = {
      pulse.enable = true;
      enable = true;
    };
    # Enable touchpad support (enabled default in most desktopManager).
    libinput.enable = true;

    # KDE
    desktopManager.plasma6.enable = true;
    displayManager.sddm.enable = true;
    displayManager.sddm.wayland.enable = true;
  };

  virtualisation.libvirtd.enable = true;

  hardware.bluetooth.enable = true;

  programs = {
    niri.enable = true; # for niri
    light.enable = true; # for niri
    mtr.enable = true;
    zsh.enable = true;

    firefox = {
      enable = true;
      languagePacks = [ "en-US" ];
    };
    vim = {
      enable = true;
      defaultEditor = true;
    };
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    virt-manager.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.athena = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "libvirtd"
      "networkmanager"
    ];
    shell = pkgs.zsh;
    useDefaultShell = true;
  };

  home-manager.users.athena = { pkgs, ... }: {
    systemd.user.sessionVariables = config.home-manager.users.athena.home.sessionVariables;
    dconf.settings."org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = lib.mkForce "Breeze";
    };
    gtk = {
      enable = true;
      theme.name = "breeze-dark";
      font = {
        name = "Noto Sans";
        size = 10;
      };
      cursorTheme = {
        name = "breeze_cursors";
        size = 24;
      };
      iconTheme.name = "breeze-dark";
      gtk2.extraConfig = ''
gtk-cursor-blink-time=1000
gtk-cursor-blink=1
      '';
      gtk3.extraConfig = {
        gtk-application-prefer-dark-theme = true;
        gtk-cursor-blink = true;
        gtk-cursor-blink-time = 1000;
      };
      gtk4.extraConfig = {
        gtk-application-prefer-dark-theme = true;
        gtk-cursor-blink = true;
        gtk-cursor-blink-time = 1000;
      };
    };
    qt = {
      enable = true;
      style.name = "breeze-dark";
    };
    xdg = {
      portal = {
        xdgOpenUsePortal = true;
        enable = true;
        extraPortals = [
          pkgs.gnome-keyring
	  pkgs.xdg-desktop-portal-gtk
        ];
        configPackages = [
          pkgs.gnome-keyring
	  pkgs.xdg-desktop-portal-gtk
        ];
      };
      mimeApps = {
        enable = true;
        defaultApplications = {
          "text/html" = "firefox.desktop";
          "x-scheme-handler/http" = "firefox.desktop";
          "x-scheme-handler/https" = "firefox.desktop";
          "x-scheme-handler/about" = "firefox.desktop";
          "x-scheme-handler/unknown" = "firefox.desktop";
          "application/pdf" = "zathura.desktop";
          "image/jpeg" = "gwenview.desktop";
          "image/jpg" = "gwenview.desktop";
          "image/png" = "gwenview.desktop";
          "image/tiff" = "gwenview.desktop";
          "image/svg+xml" = "gwenview.desktop";
          "image/webp" = "gwenview.desktop";
          "image/apng" = "gwenview.desktop";
          "image/avif" = "gwenview.desktop";
          "image/bmp" = "gwenview.desktop";
          "image/gif" = "gwenview.desktop";
        };
      };
    };
    programs = {
      alacritty = {
        enable = true;
        settings = {
	  font.size = 13;
	  window.dimensions = {
	    columns = 90;
	    lines = 30;
	  };
        };
      };
      obs-studio.enable = true;
      git = {
        enable = true;
        lfs.enable = true;
        settings.user = {
	  name = "Athena Boose";
	  email = "pestpestthechicken@yahoo.com";
	};
      };
      zsh = {
        enable = true;
        enableCompletion = true;
        syntaxHighlighting.enable = true;
        oh-my-zsh.enable = true;
	history = {
	  size = 10000;
	  path = "${config.users.users.athena.home}/.zsh_history";
	};
        initContent = ''
# trans flag
PROMPT="%(?:%{$FG[045]%}♥ %{$FG[211]%}♥ %{$FG[015]%}♥ %{$FG[211]%}♥ %{$FG[045]%}♥ :%{$FG[045]%}♥ %{$FG[211]%}♥ %{$FG[015]%}♥ %{$FG[211]%}♥ %{$FG[045]%}♥ )"
PROMPT+=' %{$fg[cyan]%}%c%{$reset_color%} '
        '';
      };
      firefox = {
        enable = true;
        languagePacks = [ "en-US" ];
  
        /* ---- POLICIES ---- */
        # Check about:policies#documentation for options.
        policies = {
          DisableTelemetry = true;
          DisableFirefoxStudies = true;
          EnableTrackingProtection = {
            Value= true;
            Locked = true;
            Cryptomining = true;
            Fingerprinting = true;
          };
          DisablePocket = true;
          DisableFirefoxAccounts = true;
          DisableAccounts = true;

          /* ---- EXTENSIONS ---- */
          # Check about:support for extension/add-on ID strings.
          # Valid strings for installation_mode are "allowed", "blocked",
          # "force_installed" and "normal_installed".
          ExtensionSettings = {
            "*".installation_mode = "blocked"; # blocks all addons except the ones specified below
            # uBlock Origin:
            "uBlock0@raymondhill.net" = {
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
              installation_mode = "force_installed";
            };
          };
  
        };
      };
      yt-dlp.enable = true;
      fastfetch.enable = true;
      hyfetch.enable = true;
      gcc.enable = true;
      fuzzel.enable = true; # for niri
      waybar.enable = true; # for niri
      swaylock.enable = true; # for niri
    };
    home.packages = with pkgs; [
      glibcInfo
      tree
      sl
      cowsay
      gimp
      qemu
      vlc
      objconv
      wget
      cmakeMinimal
      gnumake
      ghostscript
      ctags
      imagemagick
      (texlive.combine {
        inherit (texlive)
          scheme-small
          latexmk
          simplekv
          xstring
          cancel
          enumitem
          geometry
          commath
          systeme
          mathtools
          gensymb
          mhchem
          pgfplots
	  soul
          ;
      })
      octaveFull

      cargo
      rustc
      aspell
      libreoffice-qt
      hunspell
      hunspellDicts.en_US
      clang-tools
      hardinfo2
      python3
      gdb
      valgrind
      bc
      kdePackages.kclock
      kdePackages.kcolorchooser
      kdePackages.kolourpaint
      kdePackages.filelight
      kdePackages.okular
      kdePackages.gwenview
      kdePackages.kdenlive
      pandoc
      xournalpp
      blueman # for niri
      pavucontrol # for niri
      xwayland-satellite # for niri
    ];
    services = {
    	mako.enable = true; # for niri
	swayidle.enable = true; # for niri
	udiskie.enable = true;
    };
    home.stateVersion = "25.11"; # DO NOT UPDATE!
  };

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    kdePackages.ksystemlog
    kdePackages.sddm-kcm
    alacritty
    wayland-utils
    wl-clipboard
    keychain
    dnsmasq
    zathura
    htop
    man-pages
    man-pages-posix
    (vim-full.customize {
	vimrcConfig.customRC = ''
	  set number
	  set relativenumber
	  set ruler
	  set autoindent
	  set showcmd
	  set hlsearch

	  syntax on
	  filetype on
	'';
    })
  ];
  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  system = {
    copySystemConfiguration = true;
    autoUpgrade.enable = true;
  };

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.11"; # Did you read the comment?

}

