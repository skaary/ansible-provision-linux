# vim:set ft=dockerfile:
FROM ubuntu:focal
# FROM ubuntu:impish

RUN set -eux \
    && apt-get update \
    && apt-get upgrade -y \
    && apt-get install --no-install-recommends --no-install-suggests -y \
    python3-apt \
    python3-dev \
    python3-jmespath \
    python3-pip \
    python3-setuptools \
    libasound2 \
    sudo \
    curl \
    git \
    # && rm -rf /var/lib/apt/lists/* \
    && apt-get purge -y --autoremove

RUN set -eux \
    && pip3 install wheel \
    && pip3 install ansible 

# Add user with password-less sudo
RUN set -eux \
    && useradd -m -s /bin/bash skaary \
    && echo "skaary ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/skaary

# Copy files
COPY ./ /home/skaary/ansible
RUN set -eux \
    && chown -R skaary:skaary /home/skaary/ansible

# Switch to user
USER skaary

# Change working directory
WORKDIR /home/skaary/ansible

CMD ["/bin/bash", "./docker-tests.sh"]
