//Copyright 1986-2016 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2016.4 (lin64) Build 1756540 Mon Jan 23 19:11:19 MST 2017
//Date        : Mon May 28 19:52:08 2018
//Host        : Alex-Ubuntu running 64-bit Ubuntu 16.04.4 LTS
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
    DATA_OUT_AXIS_tuser,
    DATA_OUT_AXIS_tvalid,
    IRQ_Errors,
    RST,
    RST_AXI);
  input CLK;
  input [13:0]CONFIG_AXI_araddr;
  input [2:0]CONFIG_AXI_arprot;
  output [0:0]CONFIG_AXI_arready;
  input [0:0]CONFIG_AXI_arvalid;
  input [13:0]CONFIG_AXI_awaddr;
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
  output [15:0]DATA_OUT_AXIS_tuser;
  output DATA_OUT_AXIS_tvalid;
  output [5:0]IRQ_Errors;
  input RST;
  input RST_AXI;

  wire CLK;
  wire [13:0]CONFIG_AXI_araddr;
  wire [2:0]CONFIG_AXI_arprot;
  wire [0:0]CONFIG_AXI_arready;
  wire [0:0]CONFIG_AXI_arvalid;
  wire [13:0]CONFIG_AXI_awaddr;
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
  wire [15:0]DATA_OUT_AXIS_tuser;
  wire DATA_OUT_AXIS_tvalid;
  wire [5:0]IRQ_Errors;
  wire RST;
  wire RST_AXI;

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
        .DATA_OUT_AXIS_tuser(DATA_OUT_AXIS_tuser),
        .DATA_OUT_AXIS_tvalid(DATA_OUT_AXIS_tvalid),
        .IRQ_Errors(IRQ_Errors),
        .RST(RST),
        .RST_AXI(RST_AXI));
endmodule
