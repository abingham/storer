FROM cyberdojo/rack-base
LABEL maintainer=jon@jaggersoft.com

RUN adduser -D -H -u 19661 storer

WORKDIR /app
COPY . .
RUN chown -R storer . #${STORER_HOME}

ARG SHA
ENV SHA=${SHA}

USER storer
EXPOSE 4577
CMD [ "./up.sh" ]
