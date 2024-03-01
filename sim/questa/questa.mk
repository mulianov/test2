vsim:
	vsim -do sim/sim.do

docker.build:
	docker build docker -t user/questa

docker.save:
	docker save user/questa:latest -o docker/questa

docker.load:
	docker load -i docker/questa

docker.run:
	docker run -it --rm \
		-v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=unix${DISPLAY} \
		--mac-address 02:42:C0:A8:00:ff \
		--security-opt label=disable  \
		-v $(CUR_DIR):$(CUR_DIR):rw,z --workdir $(CUR_DIR) \
		mulianov/questa:latest
