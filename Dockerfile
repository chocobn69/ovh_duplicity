FROM debian:8-slim

ENV HOME=/home/duplicity
 
RUN set -x \
	&& apt-get update -y \
	&& apt-get install -y \
		bzr \
		gcc \
		librsync-dev \
		python \
		python-dev \
		python-pip \
		trickle
RUN set -x \
	&& mkdir /duplicity && cd /duplicity \
	&& bzr branch lp:duplicity \
	&& cd duplicity \
	&& pip install setuptools wheel \
	&& pip install -r requirements.txt \
	&& pip install python-swiftclient \
		python-keystoneclient \
	&& python setup.py install \
	&& rm -rf /var/lib/apt/lists/*

RUN set -x \
	&& adduser --home /home/duplicity \
		--shell /bin/bash \
		--disabled-password \
		--gecos '' -u 1896 duplicity \ 
	&& mkdir -p /home/duplicity/.cache/duplicity \ 
	&& mkdir -p /home/duplicity/.gnupg \ 
	&& chmod -R go+rwx /home/duplicity/ \ 
	&& su - duplicity -c 'duplicity --version'
	
VOLUME ["/home/duplicity/.cache/duplicity", "/home/duplicity/.gnupg"]

USER duplicity

CMD ["duplicity"]
