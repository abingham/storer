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
# setup server
#   o) cyber-dojo user owns the katas/ dir
#   o) users group has rights to /var/run/docker.sock
#   o) git is needed for reading katas in old git-format
#   o) tar is needed to tar-pipe old git-kata in tests
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

RUN adduser -D -H -u 19661 cyber-dojo
RUN addgroup cyber-dojo users
RUN apk --update --no-cache add git tar

COPY . /app
ARG PORT
EXPOSE ${PORT}
ENV PORT=${PORT}
CMD [ "./up.sh" ]

# Note that you cannot do this (call contents of up.sh directly in a CMD)
# CMD [ "bundle", "exec", "rackup", "--host", "0.0.0.0", "-p", "${PORT}" ]
# because ${...} expansions do not work in a CMD
