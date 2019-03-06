# DaKaMon

## Introduction

DaKaMon is a system for storing hydrological measurements in a structured
database and was developed within the
["Monitoringprogramm für prioritäre Stoffe zur Ableitung deutschlandweiter differenzierter Emissionsfaktoren zur Bilanzierung der Stoffeinträge aus kommunalen Kläranlagen"](https://isww.iwg.kit.edu/607_2201.php).

## License

- GPLv2 (see LICENSE.md)
- see NOTICE.md for used libraries


## Steps for Developers

 1. Clone this repository:
 ```
 git clone https://github.com/52north/dakamon.git
 ```

 - Clone [dakamon-r-tools](https://github.com/52north/dakamon-r-tools)
   repository and create docker image for shiny-server.
   If you are using Windows you have to check the `docker/shiny-server.sh` file
   for line-endings because it should be `LF` and not `CRLF`. With `CRLF` the
   shiny server does not start!
   Please replace `USER` with your username and `YYYY-MM` with the current
   values in the following commands:
```
        git clone https://github.com/52north/dakamon-r-tools.git
        cd dakamon-r-tools
        docker build -f docker/Dockerfile -t shiny-server:dakamon-$(date +%Y-%m) .
```

 - Update the according `docker-compose.yml` (dev/production) to use
   the correct shiny-server image:
```
        [...]
        shiny:
          image: shiny-server:dakamon-YYYY-MM
        [...]
```
 - Switch back to **this** repository.
 - Build SOS image (*adjust path to Dockerfile and tagname!*):
```
        docker build -f sos/Dockerfile -t sos:dakamon-$(date +%Y-%m) .
```
 - Update the according `docker-compose.yml` (dev/production) to use
    the correct sos image:
```
        [...]
        sos:
          build: .
          image: sos:dakamon-YYYY-MM
        [...]
```
 - Launch according `docker-compose.yml` for testing the set-up:
```
       user@host:~$ docker-compose --file (dev|production)/docker-compose.yml up --force-recreate --remove-orphans
```

## Steps for Users

 1. Clone this repository:
```
user@host:~/$ git clone https://github.com/52north/dakamon.git
```
 - Make the scripts executable:
```
user@host:~/$ cd dakamon
user@host:~/dakamon$ chmod +x init-vm.sh init-db.sh update-apps.sh
```
 - Run start installation script and follow the instructions on the screen:
```
user@host:~/dakamon$ sudo ./init-vm.sh
```
 - Run database initialization script and follow the instructions on the screen
```
user@host:~/dakamon$ sudo su postgres
postgres@host:/home/user/dakamon$ ./init-db.sh
```
 - Run apps install and update script:
```
user@host:~/dakamon$ sudo ./update-apps.sh
```
## Contact

- [Gräler, Benedikt](mailto:b.graeler@52north.org)


## Developer

- [Bredel, Henning](mailto:h.bredel@52north.org)
- [Hollmann, Carsten](mailto:c.hollmann@52north.org)
- [Jürrens, Eike Hinderk](mailto:e.h.juerrens@52north.org)
