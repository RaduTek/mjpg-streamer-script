# Easy script for MJPG Streamer

This is a script that starts [mjpg-streamer](https://github.com/jacksonliam/mjpg-streamer) in a screen session with the appropriate commands. This is useful for launching mjpg streamer from init scripts.

This script is set up to use a Video4Linux (V4L) USB Video Class (UVC) camera and to stream its video output over HTTP though the MJPEG protocol.

Included is also a simple web UI that lets you view either the MJPEG live stream or a still frame as JPEG.

## Requirements

-   GNU Screen: [https://www.gnu.org/software/screen/](https://www.gnu.org/software/screen/)
-   MJPG Streamer: [mjpg-streamer](https://github.com/jacksonliam/mjpg-streamer)

Use the instructions from the [mjpg-streamer](https://github.com/jacksonliam/mjpg-streamer) repository to compile and install `mjpg_streamer` for your platform/architecture.

## Usage

The [stream.sh](/stream.sh) script can take 3 commands as command line arguments:

-   `start` - Starts MJPG Streamer in a new screen session
-   `stops` - Stops an active MJPG Streamer session
-   `attach` - Attaches current terminal to MJPG Streamer session, useful to view logs and errors

They are given as the first and only command line argument to the script, like this: `./stream.sh [start|stop|attach]`.

## Configuration

Configuration for the script is stored in the `config.sh` file that is loaded from the directory that holds the script.

A sample configuration file [config.sample.sh](/config.sample.sh) is included, with explanations in comments for each parameter.

## Modifying the script for other setups

This script is set up to use a Video4Linux (V4L) USB Video Class (UVC) camera and to stream its video output over HTTP though the MJPEG protocol. This is the only setup I have tested.

The script can be adjusted for other setups, like Raspberry Pi cameras, by modifying the parameters to the input and output plugin in the script files.

The default configurations are:

```sh
INPUT_PLUGIN="$BIN_DIR/input_uvc.so -d /dev/v4l/by-id/$CAMERA_ID -r $CAMERA_RES"
OUTPUT_PLUGIN="$BIN_DIR/output_http.so -p $WEB_PORT -w $WEB_ROOT"
```
