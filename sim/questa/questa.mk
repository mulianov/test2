QUESTA_SRC_DIR = $(CUR_DIR)/sim/questa

vsim:
	vlib work
	vlog -work work -O0 -cover bcs +acc \
		$(RTL_SRC_DIR)/top.sv $(SIM_SRC_DIR)/top_tb.sv
	vsim -voptargs=+acc -debugDB -coverage -fsmdebug \
		-onfinish stop top_tb -do $(QUESTA_SRC_DIR)/sim.do

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
