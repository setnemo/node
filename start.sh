#!/bin/bash
/usr/sbin/crond -b
exec /usr/bin/supervisord -n -c /etc/supervisord.conf