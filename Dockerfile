# vi:ft=dockerfile
FROM rockylinux:8

# SYSTEM
RUN yum -y --setopt="tsflags=nodocs" update && \
    yum -y --setopt="tsflags=nodocs" install epel-release &&  \
    dnf config-manager --set-enabled powertools && \
    dnf config-manager --set-enabled extras && \
    dnf module enable -y javapackages-tools && \
    dnf group install -y "Development Tools" && \
    yum install --setopt="tsflags=nodocs" -y curl wget which \
      sudo \
      git perl ruby \
      perl-Data-Dumper perl-IPC-Cmd \
      gcc gcc-c++ make \
      java-1.8.0-openjdk maven \
      rpm-build createrepo \
      hamcrest-core junit ant-junit && \
    yum clean all && \
    rm -rf /var/cache/*

# USERS
RUN useradd -ms /bin/bash -G wheel build && \
    sed -i -e '/^%wheel/s/)\s*ALL$/) NOPASSWD: ALL/' /etc/sudoers

# REDUCE PRIVILEGE
USER build
WORKDIR /home/build
