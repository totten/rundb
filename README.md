# rundb: Quick-and-dirty local dev w/MariaDB master-slave

Launch a pair of master-slave MariaDB servers on `localhost`. The data will be stored in `$PWD/master` and `$PWD/slave`.

| Server Role | IP           | Port      | Server ID | Storage       |
|-------------|--------------|-----------|-----------|---------------|
| Master      | `127.0.0.1`  | `3330`    | `3330`    | `$PWD/master` |
| Slave       | `127.0.0.1`  | `3331`    | `3331`    | `$PWD/slave`  |

Each server has two users, `root` (no password) and `reader` (no password).

This is horrifically insecure by default. It's only for internal/local development.

## Requirements

* Use Linux or OS X on the local workstation
* Install the [nix package manager](https://nixos.org/nix/)

## Clean-Start Quick Start

The quickest way to get going is to use `clean-start`.  With one command, this will start an empty `master` and `slave`
DB with synchronization active.  Any data will be (over)written in `$PWD/master` and `$PWD/slave`.  Usage:

```bash
nix-shell https://github.com/totten/rundb/archive/master.tar.gz --command clean-start
```

You can additionally use CLI tools with these databases; however, the
commands should be called with `nix-shell`, like in these examples:

```bash
## Open an interactive bash shell
DB=master nix-shell https://github.com/totten/rundb/archive/master.tar.gz
DB=slave nix-shell https://github.com/totten/rundb/archive/master.tar.gz

## Open an interactive SQL shell (as root)
DB=master nix-shell https://github.com/totten/rundb/archive/master.tar.gz --command mysql
DB=slave nix-shell https://github.com/totten/rundb/archive/master.tar.gz --command mysql

## Open an interactive SQL shell (as reader)
DB=master nix-shell https://github.com/totten/rundb/archive/master.tar.gz --command 'mysql -u reader'
DB=slave nix-shell https://github.com/totten/rundb/archive/master.tar.gz --command 'mysql -u reader'

## Dump a copy of the 'foo' database
DB=master nix-shell https://github.com/totten/rundb/archive/master.tar.gz --command 'mysqldump foo'
DB=slave nix-shell https://github.com/totten/rundb/archive/master.tar.gz --command 'mysqldump foo'
```

The `clean-start` gets you started with one command, but it has several limitations:

* The `nix-shell` command includes a long URL.
* The `$PWD/master` and `$PWD/slave` folders are reset everytime you start.
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

## Configuration files

The configuration files are generated from templates whenever you call `rundb`. The key files are:

* [templates/common/my.cnf](templates/common/my.cnf): Configuration elements shared by master and slave DB
* [templates/master/my.cnf](templates/master/my.cnf): Configuration file for master DB
* [templates/slave/my.cnf](templates/slave/my.cnf): Configuration file for slave DB

## More example commands

Each of these examples can be execued with the master or slave.

```bash
## Open an interactive bash session
DB=master nix-shell
DB=slave nix-shell

## Open an interactive SQL session (as root)
DB=master nix-shell --command mysql
DB=slave nix-shell --command mysql

## Open an interactive SQL session (as reader)
DB=master nix-shell --command 'mysql -u reader'
DB=slave nix-shell --command 'mysql -u reader'

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
