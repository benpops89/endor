{ config, pkgs, ... }:

let
  hostname = "endor";
in
{
  fileSystems."/" = {
    device = "/dev/disk/by-label/NIXOS_SD";
    fsType = "ext4";
    options = [ "noatime" ];
  };

  boot = {
    initrd.availableKernelModules = [
      "usbhid"
      "usb_storage"
      "vc4"
      "pcie_brcmstb"
      "reset-raspberrypi"
    ];

    loader = {
      grub.enable = false;
      generic-extlinux-compatible.enable = true;
    };
  };
  boot.extraModulePackages = [];
  boot.kernelParams = [];

  hardware.enableRedistributableFirmware = true;

  networking = {
    hostName = hostname;

    bridges = {
      br0.interfaces = [ "end0" ];
    };

    defaultGateway = "10.0.1.1";
    nameservers = [ "10.0.1.1" ];

    interfaces = {
      end0 = {
        useDHCP = false;
      };
      br0 = {
        ipv4.addresses = [{
          address = "10.0.1.230";
          prefixLength = 24;
        }];
      };
    };
  };

  time.timeZone = "Europe/London";

  # Nix Settings
  nix.settings = {
    trusted-users = [ hostname ];
    experimental-features = [ "nix-command" "flakes" ];
  };

  # Enable SSH and other services
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.PermitRootLogin = "no";
  };

  # Define users
  users = {
    users.${hostname} = {
      createHome = true;
      isNormalUser = true;
      extraGroups = [ "wheel" "podman" ];
      home = "/home/endor";
      password = "";
      openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDLZTmI3ao4ZrAxFLYQ0dLHwlufS7ZAOum5SxCkESO8e2NoaVD6q6AS3ez9L14txiMSP8WnIvzEsAQYkvTvBtmuHNprh9PG+UPXn9OtU2VNZcMJZq+b8YLG5ULFG23oMHfjRogChdqWJ/JOccJVU5vbbQnkaDABb6sYH9rtCYYfCofjrz0f8yuWq1ewcE2Odp9FHq3lvJDzrcfRTRLbvcPh+WfdZwbOqhngtIWp0ljVxIUrim4KXYjLds6gAz93Y45QUUSF+9xrNnAoXLsvQbLltNxqk0JXfPWQ1H3f3kxXbhlKOXakJYT/EX/4zMWQvoZwul+6FYCvMuSxNWZtYvBsBarr7wH2WYSvVng7a0DGRajlnuJD3xAgnfcT7PxH+qkuQnP21ju1kOTX2L11CImUpSbZWte+XmEiNnedjfso/k1Ha8MtA4NVIrcg/B+BuhcQOFblPTxlD6z4oF+6iCA3lMaGF9FbfjzztmnL4u+cyM10UpFbN9XiGejoMw4P1B8= ben@pop-os"
      ];
    };
  };

  security.sudo.wheelNeedsPassword = false;

  # Example system packages
  environment.systemPackages = with pkgs; [
    vim
    git
    libraspberrypi
    raspberrypi-eeprom
    cacert
  ];

  system.stateVersion = "24.11";
}
