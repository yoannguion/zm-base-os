# vi:ft=dockerfile
FROM yoannguion/centos6:latest

# SYSTEM
RUN yum install -y sudo wget perl ruby \
    perl-Data-Dumper perl-IPC-Cmd \
    gcc gcc-c++ make \
    java-1.8.0-openjdk-devel \
    rpm-build createrepo zlib-devel gettext \
    yum clean all && \
    rm -rf /var/cache/*

# USERS
RUN groupadd -g 121 build && \
    useradd -ms /bin/bash -u 1001 -g 121 build && \
    usermod -aG wheel build && \
    sed -i -e '/^%wheel/s/)\s*ALL$/) NOPASSWD: ALL/' /etc/sudoers


# Install missing java dependencies
RUN mkdir -p /home/build/.zm-dev-tools/
RUN wget "http://mirror.metrocast.net/apache/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.tar.gz" -O - | tar --no-same-owner -xzf - -C /home/build/.zm-dev-tools/
RUN wget "https://www.apache.org/dist/ant/binaries/apache-ant-1.9.16-bin.tar.gz" --no-check-certificate -O - | tar --no-same-owner -xzf - -C /home/build/.zm-dev-tools/

# Use a newer git
RUN wget "https://www.kernel.org/pub/software/scm/git/git-2.9.5.tar.gz" --no-check-certificate -O - | tar --no-same-owner -xzf - -C /root && \
  cd /root/git-2.9.5 && ./configure --without-tcltk && \
  make -C /root/git-2.9.5 && \
  yum erase -y git && \
  make -C /root/git-2.9.5 install && \
  rm -rf /root/git-2.9.5

# REDUCE PRIVILEGE
USER build
WORKDIR /home/build
