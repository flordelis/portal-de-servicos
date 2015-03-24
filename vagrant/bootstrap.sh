#!/bin/env sh

echo 'Atualizando repositório Yum'
yum makecache fast -y
yum update -y

mkdir -p 'gds'
pushd 'gds'
  if [ -f 'jdk-8u40-linux-x64.rpm' ]; then
    echo 'Java 8 já foi baixado'
  else
    echo 'Baixando JDK'
    wget -c \
      --quiet \
      --no-cookies \
      --no-check-certificate \
      --header 'Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie' \
      'http://download.oracle.com/otn-pub/java/jdk/8u40-b25/jdk-8u40-linux-x64.rpm'
  fi

  (rpm -qa | grep -q jdk1.8.0_40-1.8.0_40-fcs.x86_64) || \
    (echo 'Instalando JDK' && rpm -Uvh 'jdk-8u40-linux-x64.rpm')

  $(java -version 2>&1 | grep -q "1.8.0_42") || \
    (echo "JDK não foi instalada corretamente" && exit -1)

  if [ -f elasticsearch-1.5.0.noarch.rpm ]; then
    echo 'ElasticSearch já foi baixado'
  else
    echo 'Baixando ElasticSearch'
    wget -c \
      --quiet \
      --no-check-certificate \
      https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.5.0.noarch.rpm
  fi

  (rpm -qa | grep -q elasticsearch-1.5.0-1.noarch) || \
    (echo 'Instalando ElasticSearch' && rpm -Uvh elasticsearch-1.5.0.noarch.rpm)

  systemctl daemon-reload
  systemctl enable elasticsearch.service
popd
