#!/bin/bash
chown -R postgres:postgres /var/lib/postgresql/data
chmod 700 /var/lib/postgresql/data

# Then start patroni
exec patroni /etc/patroni.yml
