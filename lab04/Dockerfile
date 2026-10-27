FROM jenkins/ssh-agent

RUN apt-get update \
&& apt-get install -y php-cli php-sqlite3 sqlite3 git \
&& rm -rf /var/lib/apt/lists/*

