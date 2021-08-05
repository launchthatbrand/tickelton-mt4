# Run MetaTrader in a container.
#
# Copyright (c) 2021 tick <tickelton@gmail.com>
#
# SPDX-License-Identifier:     ISC
#
# docker run \
#	--net host \
#	-v /tmp/.X11-unix:/tmp/.X11-unix \
#	-e DISPLAY \
#	-v $METATRADER_HOST_PATH:/MetaTrader \
#	--name mt \
#	tickelton/mt

# Base docker image.
FROM ubuntu:groovy

ADD https://dl.winehq.org/wine-builds/winehq.key /Release.key

# Install Wine
RUN apt-get update && \
	apt-get install -y gnupg apt-utils && \
	echo "deb http://dl.winehq.org/wine-builds/ubuntu/ groovy main" >> /etc/apt/sources.list && \
	apt-key add Release.key && \
	dpkg --add-architecture i386 && \
	apt-get update && \
	apt-get install -y --install-recommends winehq-devel \
	&& rm -rf /var/lib/apt/lists/* /Release.key

# Add wine user.
# NOTE: You might need to change the UID/GID so the
# wine user has write access to your MetaTrader
# directory at $METATRADER_HOST_PATH.
RUN groupadd -g 1000 wine \
	&& useradd -g wine -u 1000 wine \
	&& mkdir -p /home/wine/.wine && chown -R wine:wine /home/wine

# Run MetaTrader as non privileged user.
USER wine

# Autorun MetaTrader Terminal.
ENTRYPOINT [ "wine" ]
CMD [ "/MetaTrader/terminal.exe", "/portable" ]

