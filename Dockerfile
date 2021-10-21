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
COPY files/create-sftp-user.sh /usr/local/bin/
COPY files/entrypoint.sh /
RUN ["chmod", "+x", "/entrypoint.sh"]
RUN ["chmod", "+x", "/usr/local/bin/create-sftp-user.sh"]
RUN ["chmod", "+x", "/etc/ssh/sshd_config"]

EXPOSE 22

ENTRYPOINT ["/entrypoint.sh"]
