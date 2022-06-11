FROM ubuntu:latest

RUN apt-get update && apt-get install -y openssh-server
RUN mkdir /var/run/sshd
RUN echo 'root:mypassword' | chpasswd
RUN ssh-keygen -A 
RUN adduser --disabled-password --gecos " " manager && \
    echo 'manager:manager123' | chpasswd

RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
EXPOSE 22
USER manager
RUN ssh-keygen -A
USER root 
RUN /etc/init.d/ssh start
CMD ["tail", "-f", "/dev/null"]