# test FFT
import numpy as np
import struct,ctypes

def binary(num):
    return ''.join(bin(ord(c)).replace('0b', '').rjust(8, '0') for c in struct.pack('!f', num))

values = [
    "00000000000000000000000000000001",
    "00000000000000000000000000000010",
    "00000000000000000000000000000011",
    "00000000000000000000000000000100",
    "00000000000000000000000000000101",
    "00000000000000000000000000000110",
    "00000000000000000000000000000111",
    "00000000000000000000000000001000"
]

for index, each in enumerate(values):
    values.pop(index)
    each = int(each,2)
    values.insert(index, each)

print(values)

fft_values = np.fft.fft(values)

# print(fft_values)

transformed = []

for index, each in enumerate(fft_values):
    print(each.real)
    real = bin(ctypes.c_uint.from_buffer(ctypes.c_float(each.real)).value)
    # real = binary(each.real)
    print(real)
    transformed.insert(index, real[0:16])
    # np.put(fft_values, [index], real)

print(transformed)

