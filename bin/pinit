#!/bin/bash
#
# Add a bookmark to Pinboard.
#
###############################################################################

DEFAULT_TAGS="pinit"

get_creds() {
    if [ -z "$PINBOARD_USER" ]; then
        echo 'No Pinboard user specified. Set $PINBOARD_USER environment variable.'
        exit 1
    fi
    if [ -z "$PINBOARD_KEY" ]; then
        echo 'No Pinboard API key specified. Set $PINBOARD_KEY environment variable.'
        exit 1
    fi
}

get_current_window() {
    # Get the ID of the window currently under the mouse pointer.
    window_id="$(xdotool getmouselocation --shell | grep WINDOW | sed 's/.*=\(.*\)/\1/')"
    # Get the name of thw window, removing anything after the final dash (ie " - Chromium").
    window_name="$(xdotool getwindowname $window_id | sed -e 's/\(.*\)\( - .*\)$/\1/g')"
}

get_name() {
    get_current_window
    read -e -p "Enter name: " -i "$window_name" input_name
    # If the user did not input a name, use the active window name.
    if [ -z "$input_name" ]; then
        name="$window_name"
    else
        name="$input_name"
    fi
}

get_url() {
    # Get the URL from standard input, or an argument, or the clipboard.
    read -t 0 stdin
    if [ -n "$stdin" ]; then
        url="$stdin"
    elif [ -n "$1" ]; then
        url="$1"
    else
        url=$(xclip -o -selection clipboard)
    fi
    # Prompt the user for a URL.
    read -e -p "Enter URL: " -i "$url" input_url
    # If the user did input a URL, use it instead of whatever we had before.
    if [ -n "$input_url" ]; then
        url="$input_url"
    fi
    # If we still have no URL, bail out.
    if [ -z "$url" ]; then
        echo "No URL provided."
        exit 3
    fi
}

get_tags() {
    # Prompt the user for a list of tags.
    read -e -p "Enter tags: " -i "$DEFAULT_TAGS" input_tags
    # If the user did not input any tags, use the defaults.
    if [ -z "$input_tags" ]; then
        tags="$DEFAULT_TAGS"
    else
        tags="$input_tags"
    fi
}

get_toread() {
    read -e -p "Unread: " -i "no" input_toread
    if [ -z "$input_toread" ] || [[ "$input_toread" == n* ]]; then
        toread="no"
    else
        toread="yes"
    fi
}

add_pin() {
    result="$(curl -s -G --data-urlencode "url=$url" --data-urlencode "description=$name" --data-urlencode "tags=$tags" --data-urlencode "toread=$toread" "https://api.pinboard.in/v1/posts/add?auth_token=$PINBOARD_USER:$PINBOARD_KEY&format=json&replace=no")"
}

get_creds
get_url "$@"
get_name
get_tags
get_toread

echo "Creating bookmark..."
echo "	URL:	$url"
echo "	Name:	$name"
echo "	Tags:	$tags"
echo "	Unread:	$toread"

add_pin
echo "Pinboard result:"
echo "	$result"

read -p "Press any key to close"
