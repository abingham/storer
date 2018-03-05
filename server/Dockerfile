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
    ruby-bundler \
    ruby-dev \
    tar

# - - - - - - - - - - - - - -
# install ruby gems
# - - - - - - - - - - - - - -

ARG             CYBER_DOJO_HOME
COPY Gemfile  ${CYBER_DOJO_HOME}/
WORKDIR       ${CYBER_DOJO_HOME}

RUN apk --update add --virtual build-dependencies build-base \
  && bundle config --global silence_root_warning 1 \
  && bundle install \
  && gem clean \
  && apk del build-dependencies build-base \
  && rm -vrf /var/cache/apk/*

# - - - - - - - - - - - - - -
# install non-commons
# - - - - - - - - - - - - - -

RUN apk --update --no-cache add \
    git

# - - - - - - - - - - - - - -
# setup server
#   o) storer user owns the katas/ dir
# - - - - - - - - - - - - - -

RUN adduser -D -H -u 19661 storer
COPY . ${CYBER_DOJO_HOME}
RUN  chown -R storer ${CYBER_DOJO_HOME}
USER storer


ARG PORT
EXPOSE ${PORT}
ENV PORT=${PORT}

CMD [ "./up.sh" ]

# Note that you cannot do this (call contents of up.sh directly in a CMD)
# CMD [ "bundle", "exec", "rackup", "--host", "0.0.0.0", "-p", "${PORT}" ]
# because ${...} expansions do not work in a CMD
