#!/usr/bin/env bash

log() {
  printf '%s\n' "$*"
}

err() {
  printf '%s\n' "$*" >&2
}