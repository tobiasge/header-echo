FROM ubuntu:22.10 as builder

RUN export DEBIAN_FRONTEND=noninteractive \
    && apt-get update -qq \
    && apt-get upgrade \
      --yes -qq --no-install-recommends \
    && apt-get install \
      --yes -qq --no-install-recommends \
      python3-pip \
      python3-venv \
    && python3 -m venv /opt/header-echo/venv \
    && /opt/header-echo/venv/bin/python3 -m pip install --upgrade \
      pip \
      setuptools \
      wheel

COPY requirements.txt /
RUN /opt/header-echo/venv/bin/pip install \
      -r /requirements.txt

###
# Main stage
###

FROM ubuntu:22.10 as main

RUN export DEBIAN_FRONTEND=noninteractive \
    && apt-get update -qq \
    && apt-get upgrade \
      --yes -qq --no-install-recommends \
    && apt-get install \
      --yes -qq --no-install-recommends \
      ca-certificates \
      curl \
      openssl \
      python3 \
      python3-distutils \
      tini \
    && curl -sL https://nginx.org/keys/nginx_signing.key \
      > /etc/apt/trusted.gpg.d/nginx.asc && \
    echo "deb https://packages.nginx.org/unit/ubuntu/ kinetic unit" \
      > /etc/apt/sources.list.d/unit.list \
    && apt-get update -qq \
    && apt-get install \
      --yes -qq --no-install-recommends \
      unit=1.29.0-1~kinetic \
      unit-python3.10=1.29.0-1~kinetic \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /opt/header-echo/venv /opt/header-echo/venv


COPY asgi.py /opt/header-echo/app/
COPY nginx-unit.json /opt/header-echo/conf/
COPY launch-unit.sh /opt/header-echo/

WORKDIR /opt/header-echo/app

RUN mkdir -p static /opt/unit/state/ /opt/unit/tmp/ \
      && chown -R unit:root /opt/unit/ \
      && chmod -R g+w /opt/unit/

ENV LANG=C.UTF-8 PATH=/opt/netbox/venv/bin:$PATH
ENTRYPOINT [ "/usr/bin/tini", "--" ]

CMD [ "/opt/header-echo/launch-unit.sh" ]
