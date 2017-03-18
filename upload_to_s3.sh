#!/bin/bash

if [ -z $TRAVIS ]
then
	echo "This is meant to be run by travis"
	exit 0
fi

case $TRAVIS_BRANCH in
	2016-redesign)
		BUCKET="s3://website-staging.freenetproject.org/"
		;;
	*)
		echo "Unknown branch $TRAVIS_BRANCH"
		exit 1
		;;
esac

aws s3 sync --exclude '*\.(bz2|gz|aac|flac|mp3|wma|gif|jpg|jpeg|png|avi|mov|mp4|webm|woff|woff2)$' --exclude='.webassets-cache' --metadata-directive  REPLACE --content-encoding=gzip --region=us-east-1 --cache-control "public, max-age=86400" --delete output/ $BUCKET
      # gzip_cache won't deal with these
aws s3 sync --include '*\.(bz2|gz|aac|flac|mp3|wma|gif|jpg|jpeg|png|avi|mov|mp4|webm|woff|woff2)$' --exclude='.webassets-cache' --metadata-directive  REPLACE --region=us-east-1 --cache-control "public, max-age=86400" --delete output/ $BUCKET
