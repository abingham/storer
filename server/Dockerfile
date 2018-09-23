FROM  cyberdojo/rack-base
LABEL maintainer=jon@jaggersoft.com

# - - - - - - - - - - - - - -
# setup server
#   o) storer user owns the katas/ dir
# - - - - - - - - - - - - - -

RUN adduser -D -H -u 19661 storer
ARG                    STORER_HOME=/app
COPY .               ${STORER_HOME}
RUN  chown -R storer ${STORER_HOME}
#USER storer

# - - - - - - - - - - - - - - - - -
# git commit sha image is built from
# - - - - - - - - - - - - - - - - -

ARG SHA
RUN echo ${SHA} > ${STORER_HOME}/sha.txt

# - - - - - - - - - - - - - - - - -

EXPOSE 4577
CMD [ "./up.sh" ]
