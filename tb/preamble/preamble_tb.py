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

from myhdl import *
import os

module = 'preamble'
testbench = '%s_tb' % module

srcs = []

srcs.append("hdl/%s.v" % module)
srcs.append("%s.v" % testbench)

src = ' '.join(srcs)

build_cmd = "iverilog -o %s.v %s" % (testbench, src)

def bench():

    # Parameters
    WIDTH = 32
    TYPE = "PRIORITY"
    BLOCK = "REQUEST"

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

    # DUT
    if os.system(build_cmd):
        raise Exception("Error running build command")

    dut = Cosimulation(
        ("vvp -m myhdl %s.vvp -lxt2" % testbench),
        clk=clk,
        rst=rst,
        signal_in = signal_in,
        preamble_length = preamble_length,
        preamble_value = preamble_value,
        frame_length = frame_length,
        valid_in = valid_in,
        ready_in = ready_in,
        signal_out = signal_out,
        ready_out = ready_out,
        valid_out = valid_out,
        error = error,
        preamble_flag = preamble_flag
    )

    @always(delay(4))
    def clkgen():
        clk.next = not clk

    @instance
    def check():
        yield delay(100)
        yield clk.posedge
        rst.next = 1
        yield clk.posedge
        rst.next = 0
        yield clk.posedge
        yield delay(100)
        yield clk.posedge

        yield clk.posedge

        # print("test 1: data")
        # current_test.next = 1

        # yield clk.posedge

        # for i in range(32):
        #     l = [i]
        #     k = 0
        #     for y in l:
        #         k = k | 1 << y
        #     request.next = k
        #     yield clk.posedge
        #     request.next = 0
        #     yield clk.posedge

        #     assert grant == 1 << i
        #     assert grant_encoded == i

        #     yield clk.posedge

        # yield delay(100)

        # yield clk.posedge

        # print("test 2: two bits")
        # current_test.next = 2

        # for i in range(32):
        #     for j in range(32):
        #         l = [i, j]
        #         k = 0
        #         for y in l:
        #             k = k | 1 << y
        #         request.next = k
        #         yield clk.posedge
        #         request.next = 0
        #         yield clk.posedge

        #         assert grant == 1 << max(l)
        #         assert grant_encoded == max(l)

        #         request.next = 0

        #         yield clk.posedge

        # print("test 3: five bits")
        # current_test.next = 3

        # for i in range(32):
        #     l = [(i*x) % 32 for x in [1,2,3,4,5]]
        #     k = 0
        #     for y in l:
        #         k = k | 1 << y
        #     request.next = k
        #     yield clk.posedge
        #     request.next = 0
        #     yield clk.posedge

        #     assert grant == 1 << max(l)
        #     assert grant_encoded == max(l)

        #     prev = int(grant_encoded)

        #     yield clk.posedge

        # yield delay(100)

        raise StopSimulation

    return dut, clkgen, check

def test_bench():
    os.chdir(os.path.dirname(os.path.abspath(__file__)))
    sim = Simulation(bench())
    sim.run()

if __name__ == '__main__':
    print("Running test...")
    test_bench()