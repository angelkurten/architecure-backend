#!/usr/bin/env bash
./dapperdox                                              \
    -force-specification-list=true                       \
    -spec-dir=architecture/                              \
    -default-assets-dir=assets/                          \
    -assets-dir=architecture/                            \
    -bind-addr=0.0.0.0:81                                \
    -spec-dir=api_specs/                                 \
    -spec-filename=logs.json                             \
    -spec-filename=services.json                         \
    -spec-filename=notifications.json                    \
    -site-url=http://localhost:81                        \
    -log-level=trace                                     \
    -author-show-assets=false                            \
    -theme=default