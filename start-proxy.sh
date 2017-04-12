#! /bin/sh

dockerize -template /app/proxy.tmpl /app/proxy.json
java -jar /app/bin/launcher.jar /app/proxy.json