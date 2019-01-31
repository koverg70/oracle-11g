#!/usr/bin/env bash

_term() {
  echo "Caught SIGTERM signal! Killing: $child..."
  kill -SIGTERM "$child" 2>/dev/null
  wait $child
  echo "Killed $child."
}

_int() {
  echo "Caught SIGINT signal! Killing: $child..."
  kill -SIGINT "$child" 2>/dev/null
  wait $child
  echo "Killed $child."
}

trap _term SIGTERM
trap _int SIGINT

set -e
source /assets/colorecho

if [ ! -d "/opt/oracle/app/product/11.2.0/dbhome_1" ]; then
	echo_yellow "Database is not installed. Installing..."
        /assets/install.sh &
        child=$!
        wait "$child"
fi

su oracle -c "/assets/entrypoint_oracle.sh" &
child=$!
wait "$child"
