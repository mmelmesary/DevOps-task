FROM postgres:14

ENV PATH="/opt/patroni-venv/bin:$PATH"

RUN apt-get update && \
    apt-get install -y curl gnupg build-essential libpq-dev python3-venv && \
    curl https://install.citusdata.com/community/deb.sh | bash && \
    apt-get install -y postgresql-14-citus-12.1 && \
    python3 -m venv /opt/patroni-venv && \
    /opt/patroni-venv/bin/pip install --no-cache-dir \
        -r /tmp/requirements.txt && \
    rm -rf /var/lib/apt/lists/*


RUN python3 -m venv /opt/patroni-venv

COPY requirements.txt /tmp/requirements.txt
COPY sql/ /docker-entrypoint-initdb.d/
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh


RUN /opt/patroni-venv/bin/pip install --no-cache-dir -r /tmp/requirements.txt \
    && rm /tmp/requirements.txt

RUN chmod +x /usr/local/bin/docker-entrypoint.sh

RUN chown -R postgres:postgres /var/lib/postgresql/data

USER postgres

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["/etc/patroni.yml"]