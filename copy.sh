#!/bin/sh

# path:       ~/projects/vimwiki-pandoc/copy.sh
# author:     klassiker [mrdotx]
# github:     https://github.com/mrdotx/vimwiki-pandoc
# date:       2020-02-24T12:31:02+0100

notes="$HOME/Dokumente/Notes/html"

# copy to webservers
printf "%s\n" ":: Copy to hermes..."
if ping -c1 -W1 -q hermes >/dev/null 2>&1; then
    rsync --info=progress2 --delete -acL "$notes"/ alarm@hermes:/srv/http/notes/
else
    printf "%\n" ":: Can not copy files, hermes is not available!"
fi

printf "%s\n" ":: Copy to prometheus..."
if ping -c1 -W1 -q prometheus >/dev/null 2>&1; then
    rsync --info=progress2 --delete -acL "$notes"/ alarm@prometheus:/srv/http/notes/
else
    printf "%s\n" ":: Can not copy files, prometheus is not available!"
fi

printf "%s\n" ":: Copy completed!"
notify-send "Notes" "Copy complete!" --icon=messagebox_info
