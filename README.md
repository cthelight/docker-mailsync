# mbsync Docker

Yes, this is yet another docker wrapper around mbsync. Most that already exist are wildly out of date and therefore should not be used (in my opinion).

This consists of a very simple container that runs `mbsync` as a cron job (via `supercronic`) to allow for easy automation of sync jobs from mail servers.

## Use
To use the resulting docker container, the following are required:
 - A mbsyncrc file (by default at /config/mbsyncrc)
    - See the mbsync [man page](https://linux.die.net/man/1/mbsync) for details
 - A directory in which to store the resulting emails (No default. Is specified in above config)

Additionally, you can optionally specify the following variables to adjust behavior:
 - `CRON_SCHEDULE` : A cron specifier to instruct the container how often to sync mail
    - By default set to run daily at midnight
 - `MBSYNC_CMD` : The `mbsync` command you would like run
    - By default this is `mbsync -V -a -c /config/mbsyncrc`
    - Depending on use case, you may want something more complicated here


