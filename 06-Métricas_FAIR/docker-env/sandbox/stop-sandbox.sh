#!/usr/bin/env bash
$(docker-compose -f './docker-env/sandbox/docker-compose.yaml' down -v)