FROM ruby:2.6.5-stretch

WORKDIR /app

RUN curl -sSfL https://deb.nodesource.com/setup_14.x | bash - \
  && curl -sSfL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
  && apt-get update \
  && apt-get install -y \
  nodejs \
  yarn \
  && rm -rf /var/lib/apt/list/*

ARG BUNDLE_INSTALL_ARGS="-j 4"
COPY Gemfile Gemfile.lock ./
RUN bundle config --local disable_platform_warnings true \ 
  && bundle install ${BUNDLE_INSTALL_ARGS}
COPY package.json yarn.lock ./
RUN yarn install

COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]

COPY . ./

CMD ["rails", "server", "-b", "0.0.0.0"]
EXPOSE 3000
