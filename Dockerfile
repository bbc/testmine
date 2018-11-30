FROM centos:7

RUN yum update -y

RUN yum -y install gcc-c++ patch readline readline-devel zlib zlib-devel openssl-devel make
RUN yum -y install bzip2 autoconf automake libtool bison iconv-devel sqlite-devel libyaml-devel libffi-devel
RUN yum -y install mariadb-server mariadb-libs mariadb
RUN yum -y install ruby ruby-devel
RUN yum -y install mysql-devel

RUN curl -sL https://rpm.nodesource.com/setup_8.x | bash -
RUN yum install -y nodejs

RUN gem install bundler

ENV app /app

RUN mkdir $app
WORKDIR $app
ADD . $app

RUN cd $app
RUN bundle update
RUN bundle install --with production

RUN rake acts_as_taggable_on_engine:install:migrations

EXPOSE 3002