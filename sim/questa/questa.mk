QUESTA_SRC_DIR = $(CUR_DIR)/sim/questa
QUESTA_BUILD_DIR = $(CUR_DIR)/build/questa

# vcom your_file.v; restart -f; run -A;

vsim.tb:
	mkdir -p $(QUESTA_BUILD_DIR)
	cd $(QUESTA_BUILD_DIR); vlib work; \
	vlog -work work -O0 -cover bcs +acc +define+VERIFY=1  \
		+define+CLK_PERIOD=$(CLK_PERIOD) \
		$(RTL_SRC_DIR)/top.sv $(SIM_SRC_DIR)/top_tb.sv ;\
	vsim -voptargs=+acc -debugDB -coverage -fsmdebug \
		-onfinish stop top_tb -do $(QUESTA_SRC_DIR)/sim.do

vsim.clean:
	rm -rf $(QUESTA_BUILD_DIR)

docker.build:
	docker build docker -t user/questa

docker.save:
	docker save user/questa:latest -o docker/questa

docker.load:
	docker load -i docker/questa

docker.run:
	docker run -it --rm --user "$(shell id -u):$(shell id -g)" \
		-v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=unix${DISPLAY} \
		--mac-address 02:42:C0:A8:00:ff \
		--security-opt label=disable  \
		-v $(CUR_DIR):$(CUR_DIR):rw,z --workdir $(CUR_DIR) \
		mulianov/questa:latest
