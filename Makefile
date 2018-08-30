
network=si

build:
	docker build --force-rm -t eyedeekay/xd-dockersetup .

run:
	docker run -i -t -d \
		--name sam-xd \
		--network $(network) \
		--network-alias sam-xd \
		--hostname sam-xd \
		--restart always \
		--ip 172.80.80.197 \
		-p 127.0.0.1:1489:1489 \
		--volume xdstorage:/home/xd/storage \
		eyedeekay/xd-dockersetup

mon:
	docker run -i -t --rm \
		--name sam-xd-mon \
		--network $(network) \
		--network-alias sam-xd-mon \
		--hostname sam-xd-mon \
		--volume xdstorage:/home/xd/storage \
		-e DISPLAY=:0 \
		--volume /tmp/.X11-unix:/tmp/.X11-unix:ro \
		--security-opt apparmor=docker-default \
		eyedeekay/xd-dockersetup surf http://172.80.80.197:1489

lmon:
	surf http://172.80.80.197:1489


init: build run
	docker cp ~/.config/XD/storage/ sam-xd:/home/xd/storage

follow:
	docker logs -f sam-xd

restart:
	docker restart sam-xd

add:
	docker exec sam-xd XD-cli

list:
	docker exec sam-xd XD-cli list | less
