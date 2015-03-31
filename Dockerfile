# CBstats Importer
#
# VERSION               0.0.1

FROM base/arch
MAINTAINER Micah Young <micah@young.io>
ENV LANG en_US.UTF-8
ENV HOME /src
RUN mkdir /src

RUN pacman -S --refresh
RUN pacman -S --noconfirm base-devel erlang-nox git

RUN /bin/bash -c 'git clone --branch=v0.15.0 https://github.com/elixir-lang/elixir.git /src/elixir'
WORKDIR /src/elixir
RUN /bin/bash -c 'make install'

RUN /bin/bash -c 'git clone --recursive https://github.com/micahyoung/cbstats-importer.git /src/cbstats-importer'
WORKDIR /src/cbstats-importer
RUN /bin/bash -c 'mix local.hex --force && mix local.rebar --force && mix deps.get'
