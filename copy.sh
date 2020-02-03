#!/bin/sh

# path:       ~/projects/vimwiki-pandoc/copy.sh
# author:     klassiker [mrdotx]
# github:     https://github.com/mrdotx/vimwiki-pandoc
# date:       2020-02-03T13:51:55+0100

notes="$HOME/Dokumente/Notes/html"

# copy to webservers
echo "Copy to hermes..."
if ping -c1 -W1 -q hermes >/dev/null 2>&1; then
    rsync --info=progress2 --delete -acL "$notes"/ alarm@hermes:/srv/http/notes/
else
    echo "Can not copy files, hermes is not available!"
fi

echo "Copy to prometheus..."
if ping -c1 -W1 -q prometheus >/dev/null 2>&1; then
    rsync --info=progress2 --delete -acL "$notes"/ alarm@prometheus:/srv/http/notes/
else
    echo "Can not copy files, prometheus is not available!"
fi

echo "Copy completed!"
notify-send "Notes" "Copy complete!" --icon=messagebox_info
