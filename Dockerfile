FROM ubuntu:16.04

# get rid of the message: "debconf: unable to initialize frontend: Dialog"
ENV DEBIAN_FRONTEND noninteractive

# Add dependant files
ADD chkconfig /sbin/chkconfig
ADD oracle-install.sh /oracle-install.sh
ADD init.ora /
ADD initXETemp.ora /


# Prepare to install Oracle
# Install dependent libraries & tools.
RUN apt-get update && apt-get install -y -q libaio1 net-tools bc curl rlwrap && \
  apt-get install -y openssh-server openssh-client && \
  apt-get clean && \
  rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/* && \
  ln -s /usr/bin/awk /bin/awk && \
  mkdir /var/lock/subsys && \
  chmod 755 /sbin/chkconfig && \
  /oracle-install.sh

# Setup Environment variables with required values
ENV ORACLE_HOME /u01/app/oracle/product/11.2.0/xe
ENV PATH $ORACLE_HOME/bin:$PATH
ENV ORACLE_SID=XE
ENV DEFAULT_SYS_PASS oracle

# Expose required TCP ports
EXPOSE 1521
EXPOSE 8080
VOLUME ["/u01/app/oracle"]

#Set the minimum DB transaction variable valies
ENV processes 500
ENV sessions 555
ENV transactions 610

ADD entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
CMD [""]
