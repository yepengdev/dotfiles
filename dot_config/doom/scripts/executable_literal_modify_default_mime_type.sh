#!/usr/bin/env sh
for type in text/x-python text/x-shellscript text/x-c text/x-c++src text/x-markdown text/x-json application/json application/xml text/x-yaml; do
    xdg-mime default emacsclient.desktop $type
done

xdg-mime default org.mozilla.zen.desktop x-scheme-handler/http
xdg-mime default org.mozilla.zen.desktop x-scheme-handler/https
xdg-mime default org.mozilla.zen.desktop text/html
