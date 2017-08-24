FROM  cyberdojo/sinatra
LABEL maintainer=jon@jaggersoft.com

RUN apk update \
 && apk add git

RUN echo "gem 'prometheus-client'" >> /app/Gemfile \
 && apk --update add --virtual build-dependencies build-base \
 && bundle install && gem clean \
 && apk del build-dependencies \
 && rm -vrf /var/cache/apk/*

COPY . /app

ARG PORT
EXPOSE ${PORT}

ENV PORT=${PORT}
CMD [ "./up.sh" ]