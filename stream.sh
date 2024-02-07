#!/bin/bash

# Initial variables
PROJECT_NAME="MJPG Streamer"
SESSION_NAME="mjpg_streamer_session"

SCRIPT_DIR=$(dirname $0)
CONFIG_PATH="$SCRIPT_DIR/config.sh"

# Check if config file exists
if ! [ -f $CONFIG_PATH ]; then
    echo -e "Config file config.sh doesn't exist! Please create it!\nFull path: \"$CONFIG_PATH\""
    exit 1
fi

# Load config variables
source $CONFIG_PATH

# Directories
WEB_ROOT="$SCRIPT_DIR/webroot"
BIN_DIR="$SCRIPT_DIR/bin"

# Plugin parameters
INPUT_PLUGIN="$BIN_DIR/input_uvc.so -d /dev/v4l/by-id/$CAMERA_ID -r $CAMERA_RES"
OUTPUT_PLUGIN="$BIN_DIR/output_http.so -p $WEB_PORT -w $WEB_ROOT"

# Add optional web login parameter
if ! [ -z $WEB_PWD ]; then
    OUTPUT_PLUGIN="$OUTPUT_PLUGIN -c $WEB_PWD"
fi

# Start command
START_CMD="$BIN_DIR/mjpg_streamer -i '$INPUT_PLUGIN' -o '$OUTPUT_PLUGIN'"

# Functions
function list_web_addresses() {
    # Get a list of all network interfaces
    interfaces=$(ip addr show | grep "^[0-9]" | awk '{print $2}' | cut -d ':' -f 1)

    # Iterate over each network interface
    for interface in $interfaces; do
        # Retrieve the IP address for the interface
        ip_address=$(ip addr show $interface | grep "inet " | awk '{print $2}' | cut -d '/' -f 1)
        echo -e "\t\t$interface: http://$ip_address:$WEB_PORT"
    done
}

function start_cmd() {
    # Check if session is already started
    if screen -ls | grep -q "$SESSION_NAME"; then
        echo "$PROJECT_NAME is already running"
        exit 0
    fi

    echo -e "Starting $PROJECT_NAME...\n\tCamera ID: $CAMERA_ID\n\tCamera resolution: $CAMERA_RES\n\tHTTP access:"
    list_web_addresses
    
    # Start command in screen session
    screen -dmS $SESSION_NAME bash -c "$START_CMD"

    echo "Started!"
}

function stop_cmd() {
    # Check if session exists
    if ! screen -ls | grep -q "$SESSION_NAME"; then
        echo "$PROJECT_NAME is not running."
        exit 1
    fi

    echo -n "Stopping $PROJECT_NAME... "
    # Gracefully stop session
    screen -S "$SESSION_NAME" -X stuff "^C"

    echo "Stopped!"
}

function attach_cmd() {
    # Check if session exists
    if ! screen -ls | grep -q "$SESSION_NAME"; then
        echo "$PROJECT_NAME is not running."
        exit 1
    fi

    screen -r "$SESSION_NAME"
}

function print_help() {
    echo "Usage $0 [start|stop|attach]"
    exit 1
}

# Interpret commands
case "$1" in
    start)
        start_cmd
        ;;
    stop)
        stop_cmd
        ;;
    attach)
        attach_cmd
        ;;
    *)
        print_help
        ;;
esac

exit 0
