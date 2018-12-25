FROM cyberdojo/rack-base
LABEL maintainer=jon@jaggersoft.com

RUN adduser -D -H -u 19661 storer

RUN apk --update --upgrade --no-cache add git
WORKDIR /app
COPY . .
RUN chown -R storer . #${STORER_HOME}

ARG SHA
ENV SHA=${SHA}

USER storer
EXPOSE 4577
CMD [ "./up.sh" ]
