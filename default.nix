let

  pkgs = import (fetchTarball https://github.com/NixOS/nixpkgs-channels/archive/nixos-18.09.tar.gz) {};
  stdenv = pkgs.stdenv;

in
  stdenv.mkDerivation rec {
    name = "rundb";
    bin = ./bin;
    templates = ./templates;
    buildInputs = [ pkgs.mariadb pkgs.php72 pkgs.which ];
    buildCommand = ''
    '';
    shellHook = ''
      export PATH="$bin:$PATH"
      export MYSQL_BASES="$PWD"
      if [ -z "$DB" ]; then export DB=master; fi
      export RUNDB_TPL="$templates"
      export MYSQL_HOME="$MYSQL_BASES/$DB/conf"
    '';
    }

