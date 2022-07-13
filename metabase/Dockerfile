FROM eclipse-temurin:11-jre-focal

ENV FC_LANG en-US LC_CTYPE en_US.UTF-8

WORKDIR /app/

ADD . certs/
RUN apt-get update && apt-get upgrade -y && apt-get install -y --no-install-recommends ttf-dejavu && \
    # cleaning everything to reduce container size
    apt-get autoremove -y && apt-get autoclean && \
    rm -rf /var/lib/apt/lists/* && \
    # providing permissions to the nobody user
    curl https://downloads.metabase.com/latest/metabase.jar -o metabase.jar && \
    curl https://raw.githubusercontent.com/metabase/metabase/master/bin/docker/run_metabase.sh -o run_metabase.sh && \
    chmod +x run_metabase.sh && \
    chown -R nobody:nogroup /app && \
    chmod +x certs/certs.sh && cd certs/ && sh certs.sh

# confirming everything's in place
RUN keytool -list -keystore certs/rds-truststore.pkcs12 -storepass supersecretpassword

USER nobody

# expose our default runtime port
EXPOSE 3000

# run it
ENTRYPOINT ["/app/run_metabase.sh"]