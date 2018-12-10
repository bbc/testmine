FROM centos:7

RUN yum -y update
RUN yum -y groupinstall 'Development Tools'
RUN yum -y install wget libxslt-devel libyaml-devel libxml2-devel gdbm-devel libffi-devel zlib-devel openssl-devel libyaml-devel readline-devel curl-devel openssl-devel pcre-devel git memcached-devel valgrind-devel mysql-devel ImageMagick-devel ImageMagick
RUN yum -y install mariadb-server

RUN curl -sL https://rpm.nodesource.com/setup_8.x | bash -
RUN yum install -y nodejs

RUN cd /tmp
RUN wget http://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
RUN rpm -Uvh epel-release-latest-7.noarch.rpm

# ruby 2.5.1
RUN cd /usr/local/src
RUN wget "https://cache.ruby-lang.org/pub/ruby/2.5/ruby-2.5.1.tar.gz"
RUN tar -zxvf "ruby-2.5.1.tar.gz"
RUN cd ruby-2.5.1 \
    && ./configure \
    && make \
    && make install

# ruby-gems
RUN cd ..
RUN wget "https://rubygems.org/rubygems/rubygems-2.7.7.tgz"
RUN tar -zxvf "rubygems-2.7.7.tgz"
RUN cd rubygems-2.7.7 \
    && /usr/local/bin/ruby setup.rb

ENV app /app

RUN mkdir $app
WORKDIR $app
ADD . $app

RUN cd $app
RUN bundle update
RUN bundle install

RUN rake acts_as_taggable_on_engine:install:migrations

EXPOSE 3002