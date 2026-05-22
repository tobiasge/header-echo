FROM docker.io/python:3.14-slim AS builder

RUN python3 -m venv /opt/header-echo/venv \
    && /opt/header-echo/venv/bin/python3 -m pip install --upgrade \
      pip

COPY requirements.txt /
RUN /opt/header-echo/venv/bin/pip install \
      -r /requirements.txt

###
# Main stage
###

FROM docker.io/python:3.14-slim AS main

RUN export DEBIAN_FRONTEND=noninteractive \
    && apt-get update -qq \
    && apt-get upgrade \
      --yes -qq --no-install-recommends \
    && apt-get install \
      --yes -qq --no-install-recommends \
      tini \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /opt/header-echo/venv /opt/header-echo/venv

COPY asgi.py /opt/header-echo/app/
COPY launch-echo.sh /opt/header-echo/

WORKDIR /opt/header-echo/

ENV LANG=C.UTF-8 PATH=/opt/header-echo/venv/bin:$PATH
ENTRYPOINT [ "/usr/bin/tini", "--" ]

CMD [ "/opt/header-echo/launch-echo.sh" ]
