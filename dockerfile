FROM postgres:14

ENV PATH="/opt/patroni-venv/bin:$PATH"

COPY requirements.txt /tmp/requirements.txt
COPY sql/ /docker-entrypoint-initdb.d/
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

RUN apt-get update && \
    apt-get install -y curl gnupg build-essential libpq-dev python3-venv && \
    curl https://install.citusdata.com/community/deb.sh | bash && \
    apt-get update && \
    apt-cache search citus && \
    apt-get install -y postgresql-14-citus || apt-get install -y citus-14 || apt-get install -y postgresql-citus || echo "Citus package not found, continuing without it" && \
    python3 -m venv /opt/patroni-venv && \
    /opt/patroni-venv/bin/pip install --no-cache-dir -r /tmp/requirements.txt && \
    rm /tmp/requirements.txt && \
    rm -rf /var/lib/apt/lists/* && \
    chmod +x /usr/local/bin/docker-entrypoint.sh && \
    chown -R postgres:postgres /var/lib/postgresql/data

USER postgres

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]