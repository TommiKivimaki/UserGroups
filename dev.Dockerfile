FROM swift:5.2

RUN export DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true && apt-get -q update && \
    apt-get -q install -y \
    libssl-dev \
    zlib1g-dev \
    sqlite3 \
    curl \
  && rm -r /var/lib/apt/lists/*

# HEALTHCHECK --interval=5s --timeout=10s --retries=3 CMD curl --fail http://localhost:8080/cf/api/v1/alive/ || exit 1
