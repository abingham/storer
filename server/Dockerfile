FROM  cyberdojofoundation/ubuntu-build-essential:17.04
LABEL maintainer=jon@jaggersoft.com

RUN apt-get update

RUN apt-get install --yes \
    openssl ca-certificates \
    ruby ruby-dev ruby-bundler \
    bash tzdata

RUN apt-get install --yes git

#RUN adduser -D -H -u 19661 cyber-dojo

RUN echo 'gem: --no-document' > ~/.gemrc
COPY Gemfile /app/
WORKDIR /app

RUN bundle install \
 && gem clean

RUN export RACK_ENV='production'

COPY . /app

ARG PORT
EXPOSE ${PORT}

ENV PORT=${PORT}
ENV GOOGLE_APPLICATION_CREDENTIALS='/app/src/cyber-dojo-3fa0435cf100.json'

CMD [ "./up.sh" ]
