#!/bin/sh

# Alternative to "pelican -r"'s polling: use inotify
while true; do
    pelican /srv/pelican/content -o /srv/pelican/output/ -s pelicanconf.py
    inotifywait -qqr --exclude "\#.*|.*~" -e close_write,move,delete,create /srv/pelican/content /srv/pelican/config
    sleep 3
    echo "Rerunning pelican on `date`"
done
