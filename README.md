# rundb: Quick-and-dirty script for running MariaDB master-slave deployment

## Requirements

* Run Linux or OS X on the local workstation
* Install the [nix package manager](https://nixos.org/nix/)

## Connection Details

| Instance    | IP           | Port      | Server ID |
|-------------|--------------|-----------|-----------|
| `master`    | `127.0.0.1`  | `3330`    | `3330`    |
| `slave`     | `127.0.0.1`  | `3331`    | `3331`    |

| Connect As       | DSN | CLI |
|------------------|-----|-----|
| Master Root      | `mysql://root:@127.0.0.1:3330/`   | `nix-shell -A master --command mysql` |
| Master Reader    | `mysql://reader:@127.0.0.1:3330/` | `nix-shell -A master --command 'mysql -u reader'` |
| Slave Root       | `mysql://root:@127.0.0.1:3331/`   | `nix-shell -A slave --command mysql` |
| Slave Reader     | `mysql://reader:@127.0.0.1:3331/` | `nix-shell -A slave --command 'mysql -u reader'` |

This is horrifically insecure by default. It's only for internal/local development.

## Configuration files

* [master/conf/my.cnf.tmpl](master/conf/my.cnf.tmpl): Configuration file for master DB
* [slave/conf/my.cnf.tmpl](slave/conf/my.cnf.tmpl): Configuration file for slave DB
* [common/conf/my.cnf](common/conf/my.cnf): Configuration elements shared by master and slave DB

## General Design

* The folders `./master` and `./slave` store all config files and data files for the master and slave instances.
* The `rundb` command is a small wrapper for `mysql_install_db` and `mysqld` which auto-initializes config files and data files.
* The command `nix-shell -A <dbname>` (e.g. `nix-shell -A master` or `nix-shell -A slave`) sets up environment variables and
  (if necessary) downloads executables for a given database.  Use it to call `rundb`, `mysql`, `mysqldump`, `mysqladmin`, etc.

## Quick Start

```
## Download rundb scripts
git clone https://github.com/totten/rundb
cd rundb

## Start master DB. (To shutdown, press Ctrl-\)
nix-shell -A master --command rundb

## Start slave DB. (To shutdown, press Ctrl-\)
nix-shell -A slave --command rundb

## Initiate replication between the two empty DBs
nix-shell -A master --command init-repl

## Copy the "civi" DB from a civibuild site to the master+slave servers
amp sql:dump -r ~/buildkit/build/dmaster -N civi | nix-shell -A master --command 'load-db civi'
```

## More examples

Each of these examples can be execued with the master or slave.

```
## Open an interactive bash session
nix-shell -A master
nix-shell -A slave

## Open an interactive SQL session
nix-shell -A master --command mysql
nix-shell -A slave --command mysql

## Dump a copy of the 'foo' database
nix-shell -A master --command 'mysqldump foo'
nix-shell -A slave --command 'mysqldump foo'

## Destroy all state/data
nix-shell -A master --command 'rundb clear'
nix-shell -A slave --command 'rundb clear'

## Clear out all master data files. Reinitialize. Run DB in foreground with a different IP.
## To stop, press Ctrl-\
nix-shell -A master --command 'rundb clear init run --bind-address=192.168.1.10'
nix-shell -A slave --command 'rundb clear init run --bind-address=192.168.1.10'

## As above, but use alternate IP+port.
nix-shell -A master --command 'rundb clear init run --bind-address=192.168.1.10 --port=9999'
nix-shell -A slave --command 'rundb clear init run --bind-address=192.168.1.10 --port=9999'
```
