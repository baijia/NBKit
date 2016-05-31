#!/bin/bash

pod repo update && \
pod repo push baijiahulian-app-specs NBKit.podspec \
    --sources=baijiahulian-app-specs,master \
    --use-libraries \
    --allow-warnings \
    --verbose

