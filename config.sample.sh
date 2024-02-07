#!/bin/bash

# * marks required

# *Camera ID, get by "ls /dev/v4l/by-id"
CAMERA_ID=""

# *Camera resolution, must be supported by camera, e.g. 640x480
CAMERA_RES=""

# *HTTP port to make stream available to, default 8080
WEB_PORT="8080"

# Login credentials for web stream, blank for no login prompt, e.g. user:password
WEB_PWD=""
