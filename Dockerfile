FROM debian:buster
MAINTAINER Adrian Dvergsdal [atmoz.net]

ENV TZ=America/Los_Angeles
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Steps done in one RUN layer:
# - Install packages
# - OpenSSH needs /var/run/sshd to run
# - Remove generic host keys, entrypoint generates unique keys
RUN apt-get update && \
    apt-get -y install openssh-server curl unzip cron nano gettext-base && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /var/run/sshd && \
    rm -f /etc/ssh/ssh_host_*key*

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip
RUN ./aws/install

COPY files/sshd_config /etc/ssh/sshd_config
COPY files/create-sftp-user /usr/local/bin/
COPY files/entrypoint /
COPY aws/config.template /
COPY aws/credentials.template /
COPY files/prep.sh /etc/sftp.d/
COPY files/upload-files-cron /etc/cron.d/upload-files-cron

EXPOSE 22

ENTRYPOINT ["/entrypoint"]
