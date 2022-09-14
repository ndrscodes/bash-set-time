# bash-set-time
a simple bash script for setting a client's time via NTP if the current system time is so far off that a local DNS server is unable to resolve hostnames.
It uses [timeapi.io](timeapi.io) in order to get the current local time. 

In order to resolve the [timeapi](timeapi.io) server, i used `nslookup`, passing it the IP of [google's](google.com) nameserver. The DNS server to use can simply be configured by changing the `DNS` variable.

We then use `curl`'s `--resolve` flag in order to point `curl` to the correct server. This allows `curl` to retrieve the page without using our current DNS server.

If an NTP service (usually `ntpd`) is detected to be running on the system, it is stopped.
after that, `timedatectl` is used to locally configure the correct time.
This allows `ntpd` to query the configured pool servers in order to set the correct system time.
The last thing the script does is restarting the NTP service.

The script should run on most UNIX systems, it doesn't use any specialized tools. Remember to run the script with **sudo** permissions as most of the commands will only work with root privileges!

I mainly use this script in order to easily reset my [PiHole's](https://pi-hole.net/) clock after the Raspberry Pi i'm using to host it has been shut down for more than one hour. This usually causes the PiHole to not be able to resolve hostnames (likely because of DNSSEC issues).
