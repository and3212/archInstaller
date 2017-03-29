#!/bin/bash

# Author: Liam Lawrence
# Date: 3.29.17
# Main file that will make installing arch easier

# Sets up the computer
./setup.sh

# Formats partitions and installs base arch system
./install.sh

# Configures the system
./config.sh

# Finalizes everything
./postInstall
