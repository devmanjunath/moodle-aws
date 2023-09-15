#!/bin/bash

# Start Nginx in the background
nginx -g "daemon off;" &

# Check if the RESTART_NGINX environment variable is set to "true"
if [ "$RESTART_NGINX" = "true" ]; then
    echo "Restarting Nginx..."
    nginx -s reload
fi

# Keep the script running
tail -f /dev/null
