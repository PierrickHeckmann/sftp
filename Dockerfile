FROM debian:buster

# Steps done in one RUN layer:
# - Install packages
# - OpenSSH needs /var/run/sshd to run
# - Remove generic host keys, entrypoint generates unique keys
RUN apt-get update && \
    apt-get -y install openssh-server && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /var/run/sshd

COPY files/sshd_config /etc/ssh/
COPY files/create-sftp-user /usr/local/bin/
COPY files/entrypoint /
RUN ["chmod", "+x", "/entrypoint"]
RUN ["chmod", "+x", "/usr/local/bin/create-sftp-user"]
RUN ["chmod", "+x", "/etc/ssh/sshd_config"]

EXPOSE 22

ENTRYPOINT ["/entrypoint"]
