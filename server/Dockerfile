FROM  alpine:latest
LABEL maintainer=jon@jaggersoft.com

# - - - - - - - - - - - - - -
# install ruby+
#   o) git is needed for reading katas in old git-format
#   o) tar is needed to tar-pipe old git-kata in tests. This allows
#      docker-compose.yml to set read_only:true which is what
#      commander does in its docker-compose.yml file.
#      Also needed to tar-pipe test coverage out of tmpfs.
# - - - - - - - - - - - - - -

RUN apk --update --no-cache add \
    bash \
    git \
    ruby-bundler \
    ruby-dev \
    tar

# - - - - - - - - - - - - - -
# install ruby gems
# - - - - - - - - - - - - - -

COPY Gemfile /app/
WORKDIR /app

RUN apk --update add --virtual build-dependencies build-base \
  && bundle config --global silence_root_warning 1 \
  && bundle install \
  && gem clean \
  && apk del build-dependencies \
  && rm -vrf /var/cache/apk/*

# - - - - - - - - - - - - - -
# setup server
#   o) cyber-dojo user owns the katas/ dir
# - - - - - - - - - - - - - -

RUN adduser -D -H -u 19661 storer

COPY . /app

ARG PORT
EXPOSE ${PORT}
ENV PORT=${PORT}

CMD [ "./up.sh" ]

# Note that you cannot do this (call contents of up.sh directly in a CMD)
# CMD [ "bundle", "exec", "rackup", "--host", "0.0.0.0", "-p", "${PORT}" ]
# because ${...} expansions do not work in a CMD
