#!/usr/bin/env bash

signal-desktop --enable-features=UseOzonePlatform --ozone-platform=wayland --enable-features=WaylandWindowDecorations --no-sandbox %U &
sleep 1
signal-desktop --enable-features=UseOzonePlatform --ozone-platform=wayland --enable-features=WaylandWindowDecorations --no-sandbox %U &