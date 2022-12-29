# vi:ft=dockerfile
FROM yoannguion/centos6:latest

# SYSTEM
RUN yum install -y sudo rsync wget perl perl-core ncurses-devel ruby \
    perl-Data-Dumper perl-CPAN perl-IPC-Cmd perl-HTML-Tagset perl-Socket perl-libwww-perl perl-Test-Harness expat-devel zip pcre-devel \
    gcc gcc-c++ make cmake libxml2 \
    java-1.8.0-openjdk-devel \
    rpm-build createrepo zlib-devel libtool bzip2-devel check-devel json-c-devel pcre2-devel curl-devel gettext \
    yum clean all && \
    rm -rf /var/cache/*

RUN curl -L https://cpanmin.us | perl - --sudo App::cpanminus && cpanm --install Crypt::OpenSSL::Guess && cpanm --install ExtUtils::Constant --force

# USERS
RUN groupadd -g 121 build && \
    useradd -ms /bin/bash -u 1001 -g 121 build && \
    usermod -aG wheel build && \
    echo "%wheel	ALL=(ALL)	NOPASSWD: ALL" >> /etc/sudoers && \
    echo "Defaults:build        !requiretty" >> /etc/sudoers && \
    cat /etc/sudoers



# Install missing java dependencies
RUN mkdir -p /.zm-dev-tools/
RUN wget "http://mirror.metrocast.net/apache/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.tar.gz" -O - | tar --no-same-owner -xzf - -C /.zm-dev-tools/
RUN wget "https://www.apache.org/dist/ant/binaries/apache-ant-1.9.16-bin.tar.gz" --no-check-certificate -O - | tar --no-same-owner -xzf - -C /.zm-dev-tools/
RUN chown -R build: /.zm-dev-tools/

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
