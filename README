# rundb: Quick-and-dirty script for running MariaDB master-slave deployment

## Requirements

* Run Linux or OS X on the local workstation
* Install the [nix package manager](https://nixos.org/nix/)

## Download

```
git clone https://github.com/totten/rundb
cd rundb
```

## Connection Credentials

| Instance    | IP           | Port      | Root User   | Root Password |
|-------------|--------------|-----------|-------------|---------------|
| `master`    | `127.0.0.1`  | `3330`    | `root`      |               |
| `slave`     | `127.0.0.1`  | `3331`    | `root`      |               |

This is horrifically insecure by default. It's only for internal/local development.

## Configuration files

* `master/conf/my.cnf.tmpl`: Configuration file for master DB
* `slave/conf/my.cnf.tmpl`: Configuration file for slave DB
* `common/conf/my.cnf`: Configuration elements shared by master and slave DB

## Quick Commands

```
## Start master DB in foreground. To stop it, press Ctrl-\
nix-shell -A master --command rundb

## Start slave DB in foreground. To stop it, press Ctrl-\
nix-shell -A slave --command rundb

## Connect to master via CLI
nix-shell -A master --command mysql

## Connect to slave via CLI
nix-shell -A slave --command mysql

## Destroy all state files from master DB.
nix-shell -A master --command 'rundb clear'

## Destroy all state files from slave DB.
nix-shell -A slave --command 'rundb clear'
```

## Shell

You can open a shell for running mysql commands on the master instance:

```
me@localhost:~/src/rundb$ nix-shell -A master
[nix-shell:~/src/rundb]$ mysql --version
mysql  Ver 15.1 Distrib 10.2.17-MariaDB, for osx10.13 (x86_64) using readline 5.1
[nix-shell:~/src/rundb]$
```

Similarly, for interacting with the slave instance:

```
me@localhost:~/src/rundb$ nix-shell -A slave
[nix-shell:~/src/rundb]$ mysql --version
mysql  Ver 15.1 Distrib 10.2.17-MariaDB, for osx10.13 (x86_64) using readline 5.1
[nix-shell:~/src/rundb]$
```

