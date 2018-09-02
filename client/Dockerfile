FROM  alpine:3.7
LABEL maintainer=jon@jaggersoft.com

# - - - - - - - - - - - - - -
# install ruby+
#   o) git is needed for reading katas in old git-format
#   o) tar is needed in tests to
#      - tar-pipe old git-katas into the katas/ dir.
#      - tar-pipe test coverage out of /tmp tmpfs dir.
# - - - - - - - - - - - - - -

RUN apk --update --no-cache add \
    bash \
    ruby-bundler \
    ruby-dev \
    tar

# - - - - - - - - - - - - - -
# install ruby gems
# - - - - - - - - - - - - - -

ARG             STORER_HOME=/app
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
# setup client
# - - - - - - - - - - - - - -

COPY . ${STORER_HOME}
RUN  chown -R nobody:nogroup ${STORER_HOME}
USER nobody

EXPOSE 4578
CMD [ "./up.sh" ]
