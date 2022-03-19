FROM python:3.8-slim

RUN apt-get update -q \
  && apt-get install --no-install-recommends -qy \
    inetutils-ping \
  && rm -rf /var/lib/apt/lists/*

RUN rm /bin/sh && ln -s /bin/bash /bin/sh

RUN apt-get update \
&& apt-get install libjpeg-dev zlib1g-dev -y \
&& apt-get install gcc git -y \
&& apt-get install libffi-dev \
&& apt-get clean

COPY [ "requirements.txt", "/dashmachine/" ]

WORKDIR /dashmachine

RUN pip install --no-cache-dir --progress-bar off -r requirements.txt

COPY [ ".", "/dashmachine/" ]

ENV PRODUCTION=true
EXPOSE 5000
VOLUME /dashmachine/dashmachine/user_data
CMD [ "gunicorn", "--bind", "0.0.0.0:5000", "wsgi:app" ]
