FROM  cyberdojo/rack-base
LABEL maintainer=jon@jaggersoft.com

# - - - - - - - - - - - - - -
# setup client
# - - - - - - - - - - - - - -

ARG                            STORER_HOME=/app
COPY .                       ${STORER_HOME}
RUN  chown -R nobody:nogroup ${STORER_HOME}

USER nobody
EXPOSE 4578
CMD [ "./up.sh" ]
