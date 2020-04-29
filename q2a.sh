#!/bin/bash

# Get the data dump:
curl -o world_x-db.tar.gz https://downloads.mysql.com/docs/world_x-db.tar.gz

# Extract:
tar -xzvf world_x-db.tar.gz

# Load into MySQL:
sudo mysql < world_x-db/world_x.sql

# Give permissions to awkologist
sudo mysql world_x -e 'GRANT ALL ON world_x TO "awkologist" IDENTIFIED BY "awkology";'

# List our tables:
mysql -u awkologist -p world_x -e "SHOW TABLES;"