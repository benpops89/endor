{ config, pkgs, ... }:
let
  json = pkgs.formats.json { };
in 
{
  virtualisation = {
    podman.enable = true;
    oci-containers = {
      backend = "podman";
      containers = {
        nginx = import ./nginx.nix;
        echo-server = import ./echo-server.nix;
      };
    };
  };

  # Create macvlan network
  environment.etc."containers/networks/containers.json" = {
    source = json.generate "containers.json" ({
      name = "containers";
      id = "0000000000000000000000000000000000000000000000000000000000000001";
      driver = "macvlan";
      network_interface = "br0";
      subnets = [{ gateway = "10.0.1.1"; subnet= "10.0.1.0/24"; }];
      ipv6_enabled = false;
      internal = false;
      dns_enabled = false;
      ipam_options = { driver = "host-local"; };    
    });
  };
}
