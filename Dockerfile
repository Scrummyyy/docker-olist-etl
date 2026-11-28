FROM ubuntu:latest
LABEL authors="cheer"

ENTRYPOINT ["top", "-b"]