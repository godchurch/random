#!/bin/sh

repos="dotfiles foobar testing vm-browser"

for repo in $repos
do
	git clone https://github.com/godchurch/$repo.git
done
