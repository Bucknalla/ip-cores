import numpy as np

with open("output.bin", "rb") as bin_file:
    bin_file.seek(0)
    i_array = []
    q_array = []
    for x in range(0,32):
        i_binary = bin_file.read(16)
        q_binary = bin_file.read(16)
        bin_file.seek(1,1) # Skip newline
        i = int(i_binary, 2)
        q = int(q_binary, 2)
        i_array.append(i)
        q_array.append(q)
    i_array = np.array(i_array)
    q_array = np.array(q_array)
    time_array = i_array + (1j * q_array)

freq_array = np.fft.fft(time_array)
print(freq_array)

# with open("output.bin", "rb") as bin_file:
#     bin_file.seek(0)
#     time_array = []
#     for x in range(0,512):
#         time_binary = bin_file.read(32)
#         bin_file.seek(1,1) # Skip newline
#         time = int(time_binary, 2)
#         print(str(time))
#         time_array.append(time)
#     print("Length: {}".format(len(time_array)))

#     freq_array = np.fft.fft(time_array)
#     for each in freq_array:
#         print(each)