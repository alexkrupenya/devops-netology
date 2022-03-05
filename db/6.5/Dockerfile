# Elasticsearch homework
FROM  centos:7
LABEL elasticSearch image brought to you by Alexey Krupenya
ENV   ES_HOME=/usr/share/elasticsearch \
      ES_DATA=/var/lib/esearch \
      ES_CONFIG_FILE=/etc/elasticsearch/elasticsearch.yml
#Adding repository
COPY  config/elasticsearch.repo /etc/yum.repos.d/elasticsearch.repo
RUN   rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch
RUN yum install -y --enablerepo=elasticsearch elasticsearch 
#Configuring elasticsearch
COPY  config/elasticsearch.yml ${ES_CONFIG_FILE}
RUN   chown elasticsearch:elasticsearch ${ES_CONFIG_FILE}
RUN   mkdir ${ES_DATA} && \
      mkdir ${ES_DATA}/data && \
      mkdir ${ES_DATA}/log && \
      mkdir ${ES_HOME}/snapshots && \
      chown -R elasticsearch:elasticsearch ${ES_DATA} ${ES_HOME}/snapshots
USER elasticsearch
CMD ["sh", "-c", "/usr/share/elasticsearch/bin/elasticsearch"]
