#!/usr/bin/env python
"""
Copyright (c) 2014-2018 Alex Forencich
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
"""
import random
from myhdl import *
import os

# Commands
module = 'preamble'
testbench = '%s_tb' % module

srcs = []
srcs.append("hdl/%s.v" % module)
srcs.append("%s.v" % testbench)
src = ' '.join(srcs)

build_cmd = "iverilog -o %s.vvp %s" % (testbench, src) # Builds the testbench with MyHDL operatives

# Random Seeds
random.seed(1)
randrange = random.randrange

# Parameters
WIDTH = 32
TYPE = "PRIORITY"
BLOCK = "REQUEST"
ACTIVE_LOW, INACTIVE_HIGH = 0, 1

# DUT
def preamble(clk, rst, signal_in, signal_out, preamble_length, preamble_value, frame_length, valid_in, ready_in, ready_out, valid_out, error, preamble_flag):

    if os.system(build_cmd):
        raise Exception("Error running build command")

    dut = Cosimulation("vvp -m myhdl {0}.vvp -lxt2".format(testbench), **locals())
    return dut

@block
def test_bench():
    # Inputs
    clk = Signal(bool(0))
    rst = Signal(bool(0))
    signal_in = Signal(intbv(0)[WIDTH:])
    preamble_length = Signal(intbv(0)[WIDTH:])
    preamble_value = Signal(intbv(0)[WIDTH:])
    frame_length = Signal(intbv(0)[WIDTH:])
    valid_in = Signal(bool(0))
    ready_in = Signal(bool(0))

    # Outputs
    signal_out = Signal(intbv(0)[WIDTH:])
    ready_out = Signal(bool(0))
    valid_out = Signal(bool(0))
    error = Signal(bool(0))
    preamble_flag = Signal(bool(0))
    # rst = rstSignal(0, active=0, async=True)

    preamble_1 = preamble(clk, rst, signal_in, signal_out, preamble_length, preamble_value, frame_length, valid_in, ready_in, valid_out, ready_out, error, preamble_flag)

    PERIOD = delay(10)

    @always(PERIOD)
    def clkGen():
        clk.next = not clk

    @instance
    def stimulus():
        rst.next = ACTIVE_LOW
        yield clk.negedge
        rst.next = INACTIVE_HIGH
        for i in range(16):
            enable.next = min(1, randrange(3))
            yield clk.negedge
        raise StopSimulation()

    @instance
    def monitor():
        print("enable  count")
        yield rst.posedge
        while 1:
            yield clk.posedge
            yield delay(1)
            print("   %s      %s" % (int(signal_out), preamble_flag))

    return clkGen, stimulus, preamble_1, monitor

def test__bench():
    os.chdir(os.path.dirname(os.path.abspath(__file__)))
    sim = Simulation()
    sim.run()

if __name__ == '__main__':
    print("Running test...")
    test__bench()