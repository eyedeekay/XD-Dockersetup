FROM alpine:edge
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" | tee -a /etc/apk/repositories
RUN apk update
RUN apk add go git make ca-certificates musl-dev surf
RUN git clone https://github.com/majestrate/XD /usr/src/XD
WORKDIR /usr/src/XD
RUN make
RUN make install
RUN mkdir -p /home/xd/
RUN adduser -g 'xd,,,,' -h /home/xd -D xd
WORKDIR /home/xd/
USER xd
RUN XD torrents.ini & sleep 1;
RUN sed -i 's|127.0.0.1:7656|sam-host:7656|g' torrents.ini
RUN sed -i 's|127.0.0.1|sam-xd|g' torrents.ini
RUN sed -i 's|1488|1489|g' torrents.ini
RUN cat torrents.ini
CMD XD torrents.ini
