#!/bin/sh

if [ ! -e "/app/proxy.json" ]
then
    dockerize -template /app/proxy.tmpl:/app/proxy.json java -jar /app/bin/launcher.jar /app/proxy.json   
else
    java -jar /app/bin/launcher.jar /app/proxy.json
fi