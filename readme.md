## Steps

1. Create SERVICE that will start project locally on some PORT
2. Create cron job that will start monitoring localhost:PORT and restart SERVICE in needed
3. Create TUNNEL-SERVICE to remove server (to expose to internet)
4. Create cron job that will start monitoring INTERNET url for TUNNEL-SERVICE and restart TUNNEL-SERVICE if needed

-   command to start local project
-   local PORT

## [Recommended] Create tunnel-service

[port]
`sudo sh ./tunnel-create.sh 6061`

-   create service for port forwarding to remote server
-   create service for watching remote server port and restarting tunnel if needed

## [Recommended] Add new service with custom command

[service $name: 'nc-$name'][command]
`sudo sh ./service-create.sh weather_info-docker "/usr/bin/docker comopse -f /home/adunda/js/weather_info/docker-compose.yml up -d`

## [Recommended] Cron job that will watch and restart service if no accessable url

[name][url][service name for restarting]
`./monitor-add-cron.sh weather_info localhost:6061 nc-weather_Info-docker`

## [Used in monitor-add-cron] Add url watch url link and if not accessable => restart service

`sudo ./monitor.sh weather_info localhost:6061 60 'systemctl restart nc-weather_Info-docker`

## [Recommended] Delete service

`sudo sh ./service-delete.sh`
