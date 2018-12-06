FROM mongo:4.0

RUN apt-get install jq

ADD ./sync/sync-mongo.sh /

ENTRYPOINT []
CMD ["sh", "./sync-mongo.sh"]
