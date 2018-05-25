connect -url tcp:127.0.0.1:3121
source /home/alex/GitHub/ip-cores/project/ofdm_baseband/ofdm_baseband.sdk/design_1_wrapper_hw_platform_0/ps7_init.tcl
targets -set -nocase -filter {name =~"APU*" && jtag_cable_name =~ "Digilent Zybo 210279777759A"} -index 0
rst -system
after 3000
targets -set -filter {jtag_cable_name =~ "Digilent Zybo 210279777759A" && level==0} -index 1
fpga -file /home/alex/GitHub/ip-cores/project/ofdm_baseband/ofdm_baseband.sdk/design_1_wrapper_hw_platform_0/design_1_wrapper.bit
targets -set -nocase -filter {name =~"APU*" && jtag_cable_name =~ "Digilent Zybo 210279777759A"} -index 0
loadhw /home/alex/GitHub/ip-cores/project/ofdm_baseband/ofdm_baseband.sdk/design_1_wrapper_hw_platform_0/system.hdf
targets -set -nocase -filter {name =~"APU*" && jtag_cable_name =~ "Digilent Zybo 210279777759A"} -index 0
ps7_init
ps7_post_config
targets -set -nocase -filter {name =~ "ARM*#0" && jtag_cable_name =~ "Digilent Zybo 210279777759A"} -index 0
dow /home/alex/GitHub/ip-cores/project/ofdm_baseband/ofdm_baseband.sdk/ofdm_tx_baseband/Debug/ofdm_tx_baseband.elf
targets -set -nocase -filter {name =~ "ARM*#0" && jtag_cable_name =~ "Digilent Zybo 210279777759A"} -index 0
con
