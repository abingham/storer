ARG   ALPINE_VERSION
FROM  alpine:${ALPINE_VERSION}
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

ARG             STORER_HOME
COPY Gemfile  ${STORER_HOME}/
WORKDIR       ${STORER_HOME}

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
COPY . ${STORER_HOME}
RUN  chown -R storer ${STORER_HOME}
USER storer

# - - - - - - - - - - - - - - - - -
# git commit sha image is built from
# - - - - - - - - - - - - - - - - -

ARG SHA
RUN echo ${SHA} > ${STORER_HOME}/sha.txt

# - - - - - - - - - - - - - - - - -

CMD [ "./up.sh" ]
