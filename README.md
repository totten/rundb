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

| Instance    | IP           | Port      | Root User   | Root Password | Server ID |
|-------------|--------------|-----------|-------------|---------------|-----------|
| `master`    | `127.0.0.1`  | `3330`    | `root`      |               | `3330`    |
| `slave`     | `127.0.0.1`  | `3331`    | `root`      |               | `3331`    |

This is horrifically insecure by default. It's only for internal/local development.

## Configuration files

* [master/conf/my.cnf.tmpl](master/conf/my.cnf.tmpl): Configuration file for master DB
* [slave/conf/my.cnf.tmpl](slave/conf/my.cnf.tmpl): Configuration file for slave DB
* [common/conf/my.cnf](common/conf/my.cnf): Configuration elements shared by master and slave DB

## General Design

* This repo is basically a couple of `my.cnf` files with a helper script.
* The folders `./master` and `./slave` store all config files and data files for the master and slave instances.
* The `rundb` command is a smaller wrapper for `mysql_install_db` and `mysqld` which auto-initializes config files and data files.
* The command `nix-shell -A <dbname>` (e.g. `nix-shell -A master` or `nix-shell -A slave`) sets up environment variables and
  (if necessary) downloads executables for a given database.  Use it to call `rundb`, `mysql`, `mysqldump`, `mysqladmin`, etc.

## Quick Commands (master)

```
## Start master DB in foreground. To stop it, press Ctrl-\
nix-shell -A master --command rundb

## Connect to master via CLI
nix-shell -A master --command mysql

## Dump master's copy of the 'foo' database
nix-shell -A master --command 'mysqldump foo'

## Destroy all state files from master DB.
nix-shell -A master --command 'rundb clear'

## Clear out all master data files. Reinitialize. Run DB in foreground with a different IP.
## To stop, press Ctrl-\
nix-shell -A master --command 'rundb clear init run --bind-address=192.168.1.10'
```

## Quick Commands (slave)

```
## Start slave DB in foreground. To stop it, press Ctrl-\
nix-shell -A slave --command rundb

## Connect to slave via CLI
nix-shell -A slave --command mysql

## Dump slave's copy of the 'foo' database
nix-shell -A slave --command 'mysqldump foo'

## Destroy all state files from slave DB.
nix-shell -A slave --command 'rundb clear'

## Clear out all slave data files. Reinitialize. Run DB in foreground with a different IP.
## To stop, press Ctrl-\
nix-shell -A slave --command 'rundb clear init run --bind-address=192.168.1.11'
```

## Interactive Shell

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

