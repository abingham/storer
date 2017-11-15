FROM  docker:latest
LABEL maintainer=jon@jaggersoft.com

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# install ruby
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

RUN apk --update --no-cache add \
    ruby ruby-dev ruby-bundler \
    bash

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# install ruby gems
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

RUN echo 'gem: --no-document' > ~/.gemrc
COPY Gemfile /app/
WORKDIR /app

RUN apk --update add --virtual build-dependencies build-base \
  && bundle config --global silence_root_warning 1 \
  && bundle install \
  && gem clean \
  && apk del build-dependencies \
  && rm -vrf /var/cache/apk/*

RUN export RACK_ENV='production'

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# install tini (for pid 1 zombie reaping)
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# https://github.com/krallin/tini
# https://blog.phusion.nl/2015/01/20/
#    docker-and-the-pid-1-zombie-reaping-problem/

RUN apk add --update --repository http://dl-cdn.alpinelinux.org/alpine/edge/community/ tini

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# setup server
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

RUN adduser -D -H -u 19661 cyber-dojo
RUN apk add git

COPY . /app
ARG PORT
EXPOSE ${PORT}
ENV PORT=${PORT}

ENTRYPOINT [ "/sbin/tini", "--" ]
CMD [ "./up.sh" ]

# Note that you cannot do this (call contents of up.sh directly in a CMD)
# CMD [ "bundle", "exec", "rackup", "--host", "0.0.0.0", "-p", "${PORT}" ]
# because ${...} expansions do not work in a CMD
