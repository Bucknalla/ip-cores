//Copyright 1986-2016 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2016.4 (lin64) Build 1756540 Mon Jan 23 19:11:19 MST 2017
//Date        : Mon May 14 16:14:20 2018
//Host        : alex-warc running 64-bit Ubuntu 16.04.4 LTS
//Command     : generate_target design_1_wrapper.bd
//Design      : design_1_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module design_1_wrapper
   (CLK,
    CONFIG_AXI_araddr,
    CONFIG_AXI_arprot,
    CONFIG_AXI_arready,
    CONFIG_AXI_arvalid,
    CONFIG_AXI_awaddr,
    CONFIG_AXI_awprot,
    CONFIG_AXI_awready,
    CONFIG_AXI_awvalid,
    CONFIG_AXI_bready,
    CONFIG_AXI_bresp,
    CONFIG_AXI_bvalid,
    CONFIG_AXI_rdata,
    CONFIG_AXI_rready,
    CONFIG_AXI_rresp,
    CONFIG_AXI_rvalid,
    CONFIG_AXI_wdata,
    CONFIG_AXI_wready,
    CONFIG_AXI_wstrb,
    CONFIG_AXI_wvalid,
    DATA_IN_AXIS_tdata,
    DATA_IN_AXIS_tready,
    DATA_IN_AXIS_tvalid,
    DATA_OUT_AXIS_tdata,
    DATA_OUT_AXIS_tlast,
    DATA_OUT_AXIS_tready,
    DATA_OUT_AXIS_tvalid,
    ERROR,
    RST,
    RST_AXI,
    event_tlast_missing,
    frame_end,
    frame_start,
    pilot_flag);
  input CLK;
  input [14:0]CONFIG_AXI_araddr;
  input [2:0]CONFIG_AXI_arprot;
  output [0:0]CONFIG_AXI_arready;
  input [0:0]CONFIG_AXI_arvalid;
  input [14:0]CONFIG_AXI_awaddr;
  input [2:0]CONFIG_AXI_awprot;
  output [0:0]CONFIG_AXI_awready;
  input [0:0]CONFIG_AXI_awvalid;
  input [0:0]CONFIG_AXI_bready;
  output [1:0]CONFIG_AXI_bresp;
  output [0:0]CONFIG_AXI_bvalid;
  output [31:0]CONFIG_AXI_rdata;
  input [0:0]CONFIG_AXI_rready;
  output [1:0]CONFIG_AXI_rresp;
  output [0:0]CONFIG_AXI_rvalid;
  input [31:0]CONFIG_AXI_wdata;
  output [0:0]CONFIG_AXI_wready;
  input [3:0]CONFIG_AXI_wstrb;
  input [0:0]CONFIG_AXI_wvalid;
  input [31:0]DATA_IN_AXIS_tdata;
  output DATA_IN_AXIS_tready;
  input DATA_IN_AXIS_tvalid;
  output [31:0]DATA_OUT_AXIS_tdata;
  output DATA_OUT_AXIS_tlast;
  input DATA_OUT_AXIS_tready;
  output DATA_OUT_AXIS_tvalid;
  output ERROR;
  input RST;
  input RST_AXI;
  output event_tlast_missing;
  output frame_end;
  output frame_start;
  output pilot_flag;

  wire CLK;
  wire [14:0]CONFIG_AXI_araddr;
  wire [2:0]CONFIG_AXI_arprot;
  wire [0:0]CONFIG_AXI_arready;
  wire [0:0]CONFIG_AXI_arvalid;
  wire [14:0]CONFIG_AXI_awaddr;
  wire [2:0]CONFIG_AXI_awprot;
  wire [0:0]CONFIG_AXI_awready;
  wire [0:0]CONFIG_AXI_awvalid;
  wire [0:0]CONFIG_AXI_bready;
  wire [1:0]CONFIG_AXI_bresp;
  wire [0:0]CONFIG_AXI_bvalid;
  wire [31:0]CONFIG_AXI_rdata;
  wire [0:0]CONFIG_AXI_rready;
  wire [1:0]CONFIG_AXI_rresp;
  wire [0:0]CONFIG_AXI_rvalid;
  wire [31:0]CONFIG_AXI_wdata;
  wire [0:0]CONFIG_AXI_wready;
  wire [3:0]CONFIG_AXI_wstrb;
  wire [0:0]CONFIG_AXI_wvalid;
  wire [31:0]DATA_IN_AXIS_tdata;
  wire DATA_IN_AXIS_tready;
  wire DATA_IN_AXIS_tvalid;
  wire [31:0]DATA_OUT_AXIS_tdata;
  wire DATA_OUT_AXIS_tlast;
  wire DATA_OUT_AXIS_tready;
  wire DATA_OUT_AXIS_tvalid;
  wire ERROR;
  wire RST;
  wire RST_AXI;
  wire event_tlast_missing;
  wire frame_end;
  wire frame_start;
  wire pilot_flag;

  design_1 design_1_i
       (.CLK(CLK),
        .CONFIG_AXI_araddr(CONFIG_AXI_araddr),
        .CONFIG_AXI_arprot(CONFIG_AXI_arprot),
        .CONFIG_AXI_arready(CONFIG_AXI_arready),
        .CONFIG_AXI_arvalid(CONFIG_AXI_arvalid),
        .CONFIG_AXI_awaddr(CONFIG_AXI_awaddr),
        .CONFIG_AXI_awprot(CONFIG_AXI_awprot),
        .CONFIG_AXI_awready(CONFIG_AXI_awready),
        .CONFIG_AXI_awvalid(CONFIG_AXI_awvalid),
        .CONFIG_AXI_bready(CONFIG_AXI_bready),
        .CONFIG_AXI_bresp(CONFIG_AXI_bresp),
        .CONFIG_AXI_bvalid(CONFIG_AXI_bvalid),
        .CONFIG_AXI_rdata(CONFIG_AXI_rdata),
        .CONFIG_AXI_rready(CONFIG_AXI_rready),
        .CONFIG_AXI_rresp(CONFIG_AXI_rresp),
        .CONFIG_AXI_rvalid(CONFIG_AXI_rvalid),
        .CONFIG_AXI_wdata(CONFIG_AXI_wdata),
        .CONFIG_AXI_wready(CONFIG_AXI_wready),
        .CONFIG_AXI_wstrb(CONFIG_AXI_wstrb),
        .CONFIG_AXI_wvalid(CONFIG_AXI_wvalid),
        .DATA_IN_AXIS_tdata(DATA_IN_AXIS_tdata),
        .DATA_IN_AXIS_tready(DATA_IN_AXIS_tready),
        .DATA_IN_AXIS_tvalid(DATA_IN_AXIS_tvalid),
        .DATA_OUT_AXIS_tdata(DATA_OUT_AXIS_tdata),
        .DATA_OUT_AXIS_tlast(DATA_OUT_AXIS_tlast),
        .DATA_OUT_AXIS_tready(DATA_OUT_AXIS_tready),
        .DATA_OUT_AXIS_tvalid(DATA_OUT_AXIS_tvalid),
        .ERROR(ERROR),
        .RST(RST),
        .RST_AXI(RST_AXI),
        .event_tlast_missing(event_tlast_missing),
        .frame_end(frame_end),
        .frame_start(frame_start),
        .pilot_flag(pilot_flag));
endmodule
