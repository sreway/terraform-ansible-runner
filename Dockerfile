FROM hashicorp/terraform:1.3.5
ARG ANSIBLE_VERSION=5.7.1
ENV ANSIBLE_VERSION $ANSIBLE_VERSION
ENV TZ=Europe/Moscow
RUN apk --no-cache add \
        sudo \
        python3\
        py3-pip \
        openssl \
        ca-certificates \
        sshpass \
        openssh-client \
	    curl \
	    jq \
        rsync \
        tzdata \
        git && \
    apk --no-cache add --virtual build-dependencies \
        python3-dev \
        libffi-dev \
        musl-dev \
        gcc \
        cargo \
        openssl-dev \
        libressl-dev \
        build-base && \
    pip3 install --upgrade pip wheel && \
    pip3 install --upgrade cryptography cffi && \
    pip3 install ansible==$ANSIBLE_VERSION && \
    pip3 install ansible-lint && \
    pip3 install --upgrade pywinrm && \
    apk del build-dependencies && \
    rm -rf /var/cache/apk/* && \
    rm -rf /root/.cache/pip && \
    rm -rf /root/.cargo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezones && \
    mkdir -p /etc/ansible && \
    echo 'localhost' > /etc/ansible/hosts
COPY .terraformrc /root/
ENTRYPOINT []
CMD ["/bin/sh"]
