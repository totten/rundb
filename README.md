# rundb: Quick-and-dirty local dev w/MariaDB master-slave

## Requirements

* Run Linux or OS X on the local workstation
* Install the [nix package manager](https://nixos.org/nix/)

## General Design

* The folders `./master` and `./slave` store all config files and data files for the master and slave instances.
* The command `nix-shell` sets up a shell with the necessary executables/scripts. It accepts an environment variable `DB=master` or `DB=slave`. Use it run MySQL commands (`mysqldump`, `mysqladmin`, et al).
* The `rundb` command is a small wrapper for `mysql_install_db` and `mysqld` which auto-initializes config files and data files.

## Clean-Start Quick-Start

The quickest way to get going is to use `clean-start`.  With one command, this will start an empty `master` and `slave`
DB with synchronization active.  Any data will be (over)written in `$PWD/master` and `$PWD/slave`.  Usage:

```bash
nix-shell https://github.com/totten/rundb/archive/master.tar.gz --command clean-start
```

To run commands like `mysql` or `mysqldump` on the `master` or `slave`, use this notation:

```bash
## Start an interactive bash shell
DB=master nix-shell https://github.com/totten/rundb/archive/master.tar.gz
DB=slave nix-shell https://github.com/totten/rundb/archive/master.tar.gz

## Start an interactive SQL shell
DB=master nix-shell https://github.com/totten/rundb/archive/master.tar.gz --command mysql
DB=slave nix-shell https://github.com/totten/rundb/archive/master.tar.gz --command mysql

## Dump a database
DB=master nix-shell https://github.com/totten/rundb/archive/master.tar.gz --command 'mysqldump somedb'
DB=slave nix-shell https://github.com/totten/rundb/archive/master.tar.gz --command 'mysqldump somedb'
```

The `clean-start` gets you started with one command, but it has several limitations:

* You have to put a long URL when calling `nix-shell`.
* The `$PWD/master` and `$PWD/slave` data are reset everytime you start.
* The log output of both master+slave is combined into one screen.
* The master and slave nodes start together and stop together.
* You can't edit the `my.cnf` templates.

For a less heavy-handed approach, use the standard quick start.

## Standard Quick Start

```bash
## Download rundb scripts.
git clone https://github.com/totten/rundb
cd rundb

## Start master DB. (To shutdown, press Ctrl-\)
DB=master nix-shell --command rundb

## Open a new terminal.

## Start slave DB. (To shutdown, press Ctrl-\)
DB=slave nix-shell --command rundb

## Open a new terminal.

## Initiate replication between the two empty DBs
DB=master nix-shell --command init-repl
```

## Servers

| Instance    | IP           | Port      | Server ID |
|-------------|--------------|-----------|-----------|
| `master`    | `127.0.0.1`  | `3330`    | `3330`    |
| `slave`     | `127.0.0.1`  | `3331`    | `3331`    |

## Users

| User             | DSN | CLI |
|------------------|-----|-----|
| Master Root      | `mysql://root:@127.0.0.1:3330/`   | `DB=master nix-shell --command mysql` |
| Master Reader    | `mysql://reader:@127.0.0.1:3330/` | `DB=master nix-shell --command 'mysql -u reader'` |
| Slave Root       | `mysql://root:@127.0.0.1:3331/`   | `DB=slave nix-shell --command mysql` |
| Slave Reader     | `mysql://reader:@127.0.0.1:3331/` | `DB=slave nix-shell --command 'mysql -u reader'` |

This is horrifically insecure by default. It's only for internal/local development.

## Configuration files

* [templates/master/my.cnf](templates/master/my.cnf): Configuration file for master DB
* [templates/slave/my.cnf](templates/slave/my.cnf): Configuration file for slave DB
* [common/conf/my.cnf](common/conf/my.cnf): Configuration elements shared by master and slave DB

## More example commands

Each of these examples can be execued with the master or slave.

```bash
## Open an interactive bash session
DB=master nix-shell
DB=slave nix-shell

## Open an interactive SQL session
DB=master nix-shell --command mysql
DB=slave nix-shell --command mysql

## Dump a copy of the 'foo' database
DB=master nix-shell --command 'mysqldump foo'
DB=slave nix-shell --command 'mysqldump foo'

## Destroy all state/data
DB=master nix-shell --command 'rundb clear'
DB=slave nix-shell --command 'rundb clear'

## Clear out all master data files. Reinitialize. Run DB in foreground.
## To stop, press Ctrl-\
DB=master nix-shell --command 'rundb clear init run'
DB=slave nix-shell --command 'rundb clear init run'

## As above, but use alternate IP+port.
DB=master nix-shell --command 'rundb clear init run --bind-address=192.168.1.10 --port=9999'
DB=slave nix-shell --command 'rundb clear init run --bind-address=192.168.1.10 --port=9999'
```
