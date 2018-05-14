
################################################################
# This is a generated script based on design: design_1
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2016.4
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   catch {common::send_msg_id "BD_TCL-109" "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source design_1_script.tcl

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xc7z020clg484-1
   set_property BOARD_PART digilentinc.com:zedboard:part0:1.0 [current_project]
}


# CHANGE DESIGN NAME HERE
set design_name design_1

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_msg_id "BD_TCL-001" "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_msg_id "BD_TCL-002" "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_msg_id "BD_TCL-003" "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_msg_id "BD_TCL-004" "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_msg_id "BD_TCL-005" "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_msg_id "BD_TCL-114" "ERROR" $errMsg}
   return $nRet
}

##################################################################
# DESIGN PROCs
##################################################################



# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set CONFIG_AXI [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 CONFIG_AXI ]
  set_property -dict [ list \
CONFIG.ADDR_WIDTH {15} \
CONFIG.ARUSER_WIDTH {0} \
CONFIG.AWUSER_WIDTH {0} \
CONFIG.BUSER_WIDTH {0} \
CONFIG.DATA_WIDTH {32} \
CONFIG.HAS_BRESP {1} \
CONFIG.HAS_BURST {0} \
CONFIG.HAS_CACHE {0} \
CONFIG.HAS_LOCK {0} \
CONFIG.HAS_PROT {1} \
CONFIG.HAS_QOS {0} \
CONFIG.HAS_REGION {0} \
CONFIG.HAS_RRESP {1} \
CONFIG.HAS_WSTRB {1} \
CONFIG.ID_WIDTH {0} \
CONFIG.MAX_BURST_LENGTH {1} \
CONFIG.NUM_READ_OUTSTANDING {1} \
CONFIG.NUM_READ_THREADS {1} \
CONFIG.NUM_WRITE_OUTSTANDING {1} \
CONFIG.NUM_WRITE_THREADS {1} \
CONFIG.PROTOCOL {AXI4LITE} \
CONFIG.READ_WRITE_MODE {READ_WRITE} \
CONFIG.RUSER_BITS_PER_BYTE {0} \
CONFIG.RUSER_WIDTH {0} \
CONFIG.SUPPORTS_NARROW_BURST {0} \
CONFIG.WUSER_BITS_PER_BYTE {0} \
CONFIG.WUSER_WIDTH {0} \
 ] $CONFIG_AXI
  set DATA_IN_AXIS [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 DATA_IN_AXIS ]
  set_property -dict [ list \
CONFIG.HAS_TKEEP {0} \
CONFIG.HAS_TLAST {0} \
CONFIG.HAS_TREADY {1} \
CONFIG.HAS_TSTRB {0} \
CONFIG.LAYERED_METADATA {undef} \
CONFIG.TDATA_NUM_BYTES {4} \
CONFIG.TDEST_WIDTH {0} \
CONFIG.TID_WIDTH {0} \
CONFIG.TUSER_WIDTH {0} \
 ] $DATA_IN_AXIS
  set DATA_OUT_AXIS [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 DATA_OUT_AXIS ]

  # Create ports
  set CLK [ create_bd_port -dir I -type clk CLK ]
  set_property -dict [ list \
CONFIG.ASSOCIATED_BUSIF {DATA_IN_AXIS:CONFIG_AXI:DATA_OUT_AXIS} \
CONFIG.ASSOCIATED_RESET {RST_AXI:RST} \
CONFIG.FREQ_HZ {100000000} \
 ] $CLK
  set ERROR [ create_bd_port -dir O ERROR ]
  set RST [ create_bd_port -dir I -type rst RST ]
  set_property -dict [ list \
CONFIG.POLARITY {ACTIVE_LOW} \
 ] $RST
  set RST_AXI [ create_bd_port -dir I -type rst RST_AXI ]
  set_property -dict [ list \
CONFIG.POLARITY {ACTIVE_LOW} \
 ] $RST_AXI
  set event_tlast_missing [ create_bd_port -dir O -type intr event_tlast_missing ]
  set frame_end [ create_bd_port -dir O frame_end ]
  set frame_start [ create_bd_port -dir O frame_start ]
  set pilot_flag [ create_bd_port -dir O pilot_flag ]

  # Create instance: FFT_Controller_0, and set properties
  set FFT_Controller_0 [ create_bd_cell -type ip -vlnv user.org:user:FFT_Controller:0.1 FFT_Controller_0 ]

  # Create instance: Pilot_Insertion_0, and set properties
  set Pilot_Insertion_0 [ create_bd_cell -type ip -vlnv user.org:user:Pilot_Insertion:0.1 Pilot_Insertion_0 ]

  set_property -dict [ list \
CONFIG.TDATA_NUM_BYTES {4} \
 ] [get_bd_intf_pins /Pilot_Insertion_0/M00_AXIS]

  set_property -dict [ list \
CONFIG.NUM_READ_OUTSTANDING {1} \
CONFIG.NUM_WRITE_OUTSTANDING {1} \
 ] [get_bd_intf_pins /Pilot_Insertion_0/S00_AXI]

  # Create instance: Preamble_0, and set properties
  set Preamble_0 [ create_bd_cell -type ip -vlnv user.org:user:Preamble:0.1 Preamble_0 ]

  set_property -dict [ list \
CONFIG.TDATA_NUM_BYTES {4} \
 ] [get_bd_intf_pins /Preamble_0/M00_AXIS]

  set_property -dict [ list \
CONFIG.NUM_READ_OUTSTANDING {1} \
CONFIG.NUM_WRITE_OUTSTANDING {1} \
 ] [get_bd_intf_pins /Preamble_0/S00_AXI]

  # Create instance: QAM_Modulator_1, and set properties
  set QAM_Modulator_1 [ create_bd_cell -type ip -vlnv user.org:user:QAM_Modulator:0.2 QAM_Modulator_1 ]

  set_property -dict [ list \
CONFIG.TDATA_NUM_BYTES {4} \
 ] [get_bd_intf_pins /QAM_Modulator_1/M00_AXIS]

  set_property -dict [ list \
CONFIG.NUM_READ_OUTSTANDING {1} \
CONFIG.NUM_WRITE_OUTSTANDING {1} \
 ] [get_bd_intf_pins /QAM_Modulator_1/S00_AXI]

  # Create instance: axi_interconnect, and set properties
  set axi_interconnect [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect ]
  set_property -dict [ list \
CONFIG.NUM_MI {4} \
 ] $axi_interconnect

  # Create instance: xfft_0, and set properties
  set xfft_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xfft:9.0 xfft_0 ]
  set_property -dict [ list \
CONFIG.implementation_options {pipelined_streaming_io} \
CONFIG.number_of_stages_using_block_ram_for_data_and_phase_factors {2} \
CONFIG.run_time_configurable_transform_length {true} \
CONFIG.transform_length {512} \
 ] $xfft_0

  # Create interface connections
  connect_bd_intf_net -intf_net DATA_IN_AXIS_1 [get_bd_intf_ports DATA_IN_AXIS] [get_bd_intf_pins QAM_Modulator_1/S00_AXIS]
  connect_bd_intf_net -intf_net FFT_Controller_0_M00_AXIS [get_bd_intf_pins FFT_Controller_0/M00_AXIS] [get_bd_intf_pins xfft_0/S_AXIS_CONFIG]
  connect_bd_intf_net -intf_net Pilot_Insertion_0_M00_AXIS [get_bd_intf_pins Pilot_Insertion_0/M00_AXIS] [get_bd_intf_pins xfft_0/S_AXIS_DATA]
  connect_bd_intf_net -intf_net Preamble_0_M00_AXIS [get_bd_intf_pins Pilot_Insertion_0/S00_AXIS] [get_bd_intf_pins Preamble_0/M00_AXIS]
  connect_bd_intf_net -intf_net QAM_Modulator_1_M00_AXIS [get_bd_intf_pins Preamble_0/S00_AXIS] [get_bd_intf_pins QAM_Modulator_1/M00_AXIS]
  connect_bd_intf_net -intf_net S00_AXI_1 [get_bd_intf_ports CONFIG_AXI] [get_bd_intf_pins axi_interconnect/S00_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_M00_AXI [get_bd_intf_pins QAM_Modulator_1/S00_AXI] [get_bd_intf_pins axi_interconnect/M00_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_M01_AXI [get_bd_intf_pins Preamble_0/S00_AXI] [get_bd_intf_pins axi_interconnect/M01_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_M02_AXI [get_bd_intf_pins Pilot_Insertion_0/S00_AXI] [get_bd_intf_pins axi_interconnect/M02_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_M03_AXI [get_bd_intf_pins FFT_Controller_0/S00_AXI] [get_bd_intf_pins axi_interconnect/M03_AXI]
  connect_bd_intf_net -intf_net xfft_0_M_AXIS_DATA [get_bd_intf_ports DATA_OUT_AXIS] [get_bd_intf_pins xfft_0/M_AXIS_DATA]

  # Create port connections
  connect_bd_net -net ARESETN_1 [get_bd_ports RST] [get_bd_pins FFT_Controller_0/m00_axis_aresetn] [get_bd_pins FFT_Controller_0/s00_axi_aresetn] [get_bd_pins Pilot_Insertion_0/m00_axis_aresetn] [get_bd_pins Pilot_Insertion_0/s00_axi_aresetn] [get_bd_pins Pilot_Insertion_0/s00_axis_aresetn] [get_bd_pins Preamble_0/m00_axis_aresetn] [get_bd_pins Preamble_0/s00_axi_aresetn] [get_bd_pins Preamble_0/s00_axis_aresetn] [get_bd_pins QAM_Modulator_1/m00_axis_aresetn] [get_bd_pins QAM_Modulator_1/s00_axi_aresetn] [get_bd_pins QAM_Modulator_1/s00_axis_aresetn]
  connect_bd_net -net ARESETN_2 [get_bd_ports RST_AXI] [get_bd_pins axi_interconnect/ARESETN] [get_bd_pins axi_interconnect/M00_ARESETN] [get_bd_pins axi_interconnect/M01_ARESETN] [get_bd_pins axi_interconnect/M02_ARESETN] [get_bd_pins axi_interconnect/M03_ARESETN] [get_bd_pins axi_interconnect/S00_ARESETN]
  connect_bd_net -net Pilot_Insertion_0_frame_end [get_bd_ports frame_end] [get_bd_pins Pilot_Insertion_0/frame_end]
  connect_bd_net -net Pilot_Insertion_0_frame_start [get_bd_ports frame_start] [get_bd_pins Pilot_Insertion_0/frame_start]
  connect_bd_net -net Pilot_Insertion_0_pilot_flag [get_bd_ports pilot_flag] [get_bd_pins Pilot_Insertion_0/pilot_flag]
  connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_ports CLK] [get_bd_pins FFT_Controller_0/m00_axis_aclk] [get_bd_pins FFT_Controller_0/s00_axi_aclk] [get_bd_pins Pilot_Insertion_0/m00_axis_aclk] [get_bd_pins Pilot_Insertion_0/s00_axi_aclk] [get_bd_pins Pilot_Insertion_0/s00_axis_aclk] [get_bd_pins Preamble_0/m00_axis_aclk] [get_bd_pins Preamble_0/s00_axi_aclk] [get_bd_pins Preamble_0/s00_axis_aclk] [get_bd_pins QAM_Modulator_1/m00_axis_aclk] [get_bd_pins QAM_Modulator_1/s00_axi_aclk] [get_bd_pins QAM_Modulator_1/s00_axis_aclk] [get_bd_pins axi_interconnect/ACLK] [get_bd_pins axi_interconnect/M00_ACLK] [get_bd_pins axi_interconnect/M01_ACLK] [get_bd_pins axi_interconnect/M02_ACLK] [get_bd_pins axi_interconnect/M03_ACLK] [get_bd_pins axi_interconnect/S00_ACLK] [get_bd_pins xfft_0/aclk]
  connect_bd_net -net xfft_0_event_frame_started [get_bd_pins Pilot_Insertion_0/event_frame_started] [get_bd_pins xfft_0/event_frame_started]
  connect_bd_net -net xfft_0_event_tlast_missing [get_bd_ports event_tlast_missing] [get_bd_pins xfft_0/event_tlast_missing]
  connect_bd_net -net xfft_0_event_tlast_unexpected [get_bd_ports ERROR] [get_bd_pins xfft_0/event_tlast_unexpected]

  # Create address segments
  create_bd_addr_seg -range 0x00001000 -offset 0x00003000 [get_bd_addr_spaces CONFIG_AXI] [get_bd_addr_segs FFT_Controller_0/S00_AXI/S00_AXI_reg] SEG_FFT_Controller_0_S00_AXI_reg
  create_bd_addr_seg -range 0x00001000 -offset 0x00002000 [get_bd_addr_spaces CONFIG_AXI] [get_bd_addr_segs Pilot_Insertion_0/S00_AXI/S00_AXI_reg] SEG_Pilot_Insertion_0_S00_AXI_reg
  create_bd_addr_seg -range 0x00001000 -offset 0x00000000 [get_bd_addr_spaces CONFIG_AXI] [get_bd_addr_segs Preamble_0/S00_AXI/S00_AXI_reg] SEG_Preamble_0_S00_AXI_reg
  create_bd_addr_seg -range 0x00001000 -offset 0x00001000 [get_bd_addr_spaces CONFIG_AXI] [get_bd_addr_segs QAM_Modulator_1/S00_AXI/S00_AXI_reg] SEG_QAM_Modulator_1_S00_AXI_reg

  # Perform GUI Layout
  regenerate_bd_layout -layout_string {
   guistr: "# # String gsaved with Nlview 6.6.5b  2016-09-06 bk=1.3687 VDI=39 GEI=35 GUI=JA:1.6
#  -string -flagsOSRD
preplace port pilot_flag -pg 1 -y 370 -defaultsOSRD
preplace port RST_AXI -pg 1 -y 220 -defaultsOSRD
preplace port frame_end -pg 1 -y 410 -defaultsOSRD
preplace port RST -pg 1 -y 40 -defaultsOSRD
preplace port CLK -pg 1 -y 60 -defaultsOSRD
preplace port DATA_OUT_AXIS -pg 1 -y 90 -defaultsOSRD
preplace port CONFIG_AXI -pg 1 -y 180 -defaultsOSRD
preplace port frame_start -pg 1 -y 390 -defaultsOSRD
preplace port event_tlast_missing -pg 1 -y 170 -defaultsOSRD
preplace port ERROR -pg 1 -y 150 -defaultsOSRD
preplace port DATA_IN_AXIS -pg 1 -y 110 -defaultsOSRD
preplace inst Pilot_Insertion_0 -pg 1 -lvl 4 -y 390 -defaultsOSRD
preplace inst axi_interconnect -pg 1 -lvl 1 -y 300 -defaultsOSRD
preplace inst QAM_Modulator_1 -pg 1 -lvl 2 -y 180 -defaultsOSRD
preplace inst Preamble_0 -pg 1 -lvl 3 -y 120 -defaultsOSRD
preplace inst FFT_Controller_0 -pg 1 -lvl 4 -y 170 -defaultsOSRD
preplace inst xfft_0 -pg 1 -lvl 5 -y 200 -defaultsOSRD
preplace netloc DATA_IN_AXIS_1 1 0 2 NJ 110 310J
preplace netloc xfft_0_event_frame_started 1 3 3 950 70 NJ 70 1630
preplace netloc xfft_0_event_tlast_unexpected 1 5 1 1640J
preplace netloc Pilot_Insertion_0_M00_AXIS 1 4 1 1270
preplace netloc axi_interconnect_M01_AXI 1 1 2 340 50 NJ
preplace netloc ARESETN_1 1 0 4 NJ 40 330 40 630 240 940
preplace netloc QAM_Modulator_1_M00_AXIS 1 2 1 610
preplace netloc ARESETN_2 1 0 1 20
preplace netloc xfft_0_M_AXIS_DATA 1 5 1 1640J
preplace netloc S00_AXI_1 1 0 1 NJ
preplace netloc axi_interconnect_M02_AXI 1 1 3 NJ 310 NJ 310 N
preplace netloc Pilot_Insertion_0_frame_end 1 4 2 NJ 410 NJ
preplace netloc xfft_0_event_tlast_missing 1 5 1 1650J
preplace netloc FFT_Controller_0_M00_AXIS 1 4 1 1250
preplace netloc processing_system7_0_FCLK_CLK0 1 0 5 30 60 320 60 620 250 930 80 1260J
preplace netloc axi_interconnect_M00_AXI 1 1 1 350
preplace netloc axi_interconnect_M03_AXI 1 1 3 NJ 330 NJ 330 910
preplace netloc Preamble_0_M00_AXIS 1 3 1 920
preplace netloc Pilot_Insertion_0_frame_start 1 4 2 NJ 390 NJ
preplace netloc Pilot_Insertion_0_pilot_flag 1 4 2 NJ 370 NJ
levelinfo -pg 1 0 170 480 770 1100 1450 1670 -top -10 -bot 520
",
}

  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


