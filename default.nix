let

  pkgs = import (fetchTarball https://github.com/NixOS/nixpkgs-channels/archive/nixos-18.09.tar.gz) {};
  stdenv = pkgs.stdenv;

in rec {

  master = stdenv.mkDerivation rec {
    name = "qdb-master";
    bin = ./bin;
    buildInputs = [ pkgs.mariadb ];
    buildCommand = ''
    '';
    shellHook = ''
      export PATH="$bin:$PATH"
      export MYSQL_BASE="$PWD/master"
      export MYSQL_HOME="$MYSQL_BASE/conf"
    '';
    };


  slave =  stdenv.mkDerivation rec {
    name = "qdb-slave";
    bin = ./bin;
    buildInputs = [ pkgs.mariadb ];
    buildCommand = ''
    '';
    shellHook = ''
      export PATH="$bin:$PATH"
      export MYSQL_BASE="$PWD/slave"
      export MYSQL_HOME="$MYSQL_BASE/conf"
    '';
    };

}
