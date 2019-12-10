FROM openjdk:8-jre-alpine

ARG scmRevision
ARG scmBranch

LABEL scm.commit=${scmRevision} scm.branch=${scmBranch}
# Download Couchbase Elasticsearch Connector (Standalone)
ADD http://packages.couchbase.com/clients/connectors/elasticsearch/4.2.0/couchbase-elasticsearch-connector-4.2.0.zip /home/cbes/
# ADD couchbase-elasticsearch-connector-4.2.0.zip /home/cbes/
# Unpack and remove archive and strip initial folder.
RUN \
 unzip /home/cbes/*.zip \
 -d /home/cbes/ \
 -q \
# Couchbase has bugged 4.0.0 release zip, with multiple file entries, need “overwrite” flag…
 -o \
 && rm /home/cbes/*.zip \
 && mv /home/cbes/couchbase-elasticsearch-connector-*/* /home/cbes/ \
 && rmdir /home/cbes/couchbase-elasticsearch-connector-*
# Overwrite with our own configurations for cbes.
COPY ./custom/config/* /home/cbes/config/
COPY ./custom/secrets/* /home/cbes/secrets/

# Set entrypoint to binary (script that runs the JAR)
ENTRYPOINT ["/home/cbes/bin/cbes"]