let

  pkgs = import (fetchTarball https://github.com/NixOS/nixpkgs-channels/archive/nixos-18.09.tar.gz) {};
  stdenv = pkgs.stdenv;

  mkdbms = {dbmsName}: stdenv.mkDerivation rec {
    name = "rundb-${dbmsName}";
    bin = ./bin;
    buildInputs = [ pkgs.mariadb ];
    buildCommand = ''
    '';
    shellHook = ''
      export PATH="$bin:$PATH"
      export MYSQL_BASE="$PWD/'' + dbmsName + ''"
      export MYSQL_HOME="$MYSQL_BASE/conf"
    '';
    };

in rec {

  master = mkdbms { dbmsName = "master"; };
  slave = mkdbms { dbmsName = "slave"; };

}
