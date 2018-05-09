#!/bin/env bash

do_backup() {
	docker run --rm -it \
	      -v $PWD/cache:/home/duplicity/.cache/duplicity \
	      -v $PWD/gnupg:/home/duplicity/.gnupg \
	      -v $PWD/config.json:/home/duplicity/config.json:ro \
	      -v $1:/data:ro \
	      duplicity:latest \
	      duplicity \
	        --file-prefix-manifest 'hot_' \
		--file-prefix-signature 'hot_' \
		--file-prefix-archive 'cold_' \
	      	--full-if-older-than=6M \
		--allow-source-mismatch \
	        /data 'multi:///home/duplicity/config.json?mode=mirror&onfail=abort'
}

_print() { printf "\e[1m%s\e[0m\n" "$1"; }


_print 'Starting backup'

_print 'Backup datas'
do_backup /home/choco/datas
