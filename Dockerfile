
FROM       ubuntu:18.04
MAINTAINER J. Norment "https://github.com/cognitiaclaeves"

RUN apt-get update

RUN apt-get install -y openssh-server
RUN mkdir /var/run/sshd

RUN useradd -ms /bin/bash jae

# Change sshd config to use non-privileged port and only allow ssh-key login
RUN sed -ri 's/.*PasswordAuthentication\s+.*/PasswordAuthentication no/' /etc/ssh/sshd_config \
 && sed -ri 's/.*PermitRootLogin\s+.*/PermitRootLogin no/' /etc/ssh/sshd_config \
 && sed -ri 's/.*ChallengeResponseAuthentication\s+.*/ChallengeResponseAuthentication no/' /etc/ssh/sshd_config \
 && sed -ri 's/.*UsePAM\s+.*/UsePAM no/' /etc/ssh/sshd_config \
 && sed -ri 's/.*Port\s+.*/Port 2222/' /etc/ssh/sshd_config

RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY authorized_keys /home/jae/.ssh/authorized_keys

RUN chgrp jae /etc/ssh/ssh_host_rsa_key && chgrp jae /etc/ssh/ssh_host_ecdsa_key && chgrp jae /etc/ssh/ssh_host_ed25519_key \
 && chmod g+r /etc/ssh/ssh_host_rsa_key && chmod g+r /etc/ssh/ssh_host_ecdsa_key && chmod g+r /etc/ssh/ssh_host_ed25519_key \
 && chown -R jae:jae /home/jae/.ssh && chmod -R 700 /home/jae/.ssh

# Run as user
user jae
WORKDIR /home/jae

EXPOSE 2222

# Run in background, with debug log available to docker logs
CMD ["/usr/sbin/sshd", "-dD"]

