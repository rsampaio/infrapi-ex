FROM alpine:latest

#RUN apt-get update && apt-get -y install wget && \
#    wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb && sudo dpkg -i erlang-solutions_1.0_all.deb && \
#    apt-get update && apt-get -y install esl-erlang elixir

RUN apk update && \
    apk add elixir erlang-ssl erlang-erts erlang-syntax-tools erlang-tools erlang-erl-interface erlang-public-key erlang-crypto erlang-parsetools erlang-dev gettext-dev musl-dev gcc make grep postgresql-client

RUN adduser -D -h /app app

USER app
COPY . /app

ENV MIX_ENV=prod
WORKDIR /app
RUN mix local.hex --force && \
    mix local.rebar --force && \
    mix deps.clean --all && \
    mix deps.get && \
    mix deps.compile && \
    mix compile

CMD ["mix", "phoenix.server", "--production"]
