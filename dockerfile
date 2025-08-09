FROM citusdata/citus:12.1.0

# Install dependencies
RUN apt-get update && \
    apt-get install -y python3-venv curl build-essential libpq-dev && \
    python3 -m venv /opt/patroni-venv && \
    /opt/patroni-venv/bin/pip install --no-cache-dir \
        "psycopg2-binary>=2.9" \
        "patroni[etcd]" && \
    rm -rf /var/lib/apt/lists/*

ENV PATH="/opt/patroni-venv/bin:$PATH"

# Copy Patroni config
COPY patroni.yml /etc/patroni.yml
COPY sql/ /docker-entrypoint-initdb.d/

CMD ["patroni", "/etc/patroni.yml"]
