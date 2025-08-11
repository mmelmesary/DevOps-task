FROM postgres:14

# Install Citus
RUN apt-get update && apt-get install -y curl gnupg
RUN curl https://install.citusdata.com/community/deb.sh | bash
RUN apt-get -y install postgresql-14-citus-12.1

# Install dependencies
RUN apt-get update && \
    apt-get install -y python3-venv curl build-essential libpq-dev && \
    python3 -m venv /opt/patroni-venv && \
    /opt/patroni-venv/bin/pip install --no-cache-dir \
        "psycopg2-binary>=2.9" \
        "patroni[etcd3]" && \
    rm -rf /var/lib/apt/lists/*

ENV PATH="/opt/patroni-venv/bin:$PATH"


COPY sql/ /docker-entrypoint-initdb.d/
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

RUN chown -R postgres:postgres /var/lib/postgresql/data

USER postgres


ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["/etc/patroni.yml"]