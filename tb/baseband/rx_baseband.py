import numpy as np
import commpy as cp
import scipy.interpolate
import matplotlib.pyplot as plt
import math, os

# assumes that there is no transmission noise, i.e. what is sent is what arrives


class OFDM_RX():
  def __init__(self,input_file="output.bin"):
    # Configure Script Variables
    self.Chunk_Size = 4096 # In bytes
    self.Symbols = "symbols.bin"
    # Configure OFDM Variables

    self.K = 512 # Number of OFDM subcarriers
    self.CP = self.K * 0.25 # Length of the cyclic prefix: % of the block
    self.P = 8 # Number of pilot carriers per OFDM block
    self.P_Value = 3+3j # The known complex value each pilot transmits
    self.MU = 16 # Number of bits per symbol (i.e. 16QAM) - NOTE: Must have integer sqrt(MU) 
    self.Pr = 32 # Number of preamble carriers
    self.Pr_Value = 1+1j # 
    self.Symbol_Size = self.K + self.P + self.Pr
    
    self.prepare_ofdm_symbol(input_file)

  def prepare_ofdm_symbol(self, input_file):
    if (os.stat(input_file).st_size == 0):
        print("Please run testbench to generate output.bin")
    try:
        with open(input_file,"r") as file:
            with open("symbols.bin", "w") as target:
                for index, data in enumerate(file):
                  if((index % self.Symbol_Size) is 0):
                      target.write("-\n")
                  target.write(str(data))
                target.close()
        file.close()
    except IOError as e:
        print(e.args[1])

  # begin receive procedure
  def receive(self):
    with open(self.Symbols) as binary:
      for index, symbol in enumerate(self.__each_frame(binary, separator='-')):
        print("OFDM Frame: "+str(index))
        symbol = symbol.split("\n")
        symbol = [x for x in symbol if x != ""] # Remove any fragments from code
        print("Expected Length: {0} | {1}".format(self.Symbol_Size,len(symbol)))
        if(len(symbol) != self.Symbol_Size):
          print("Simulation Failed - Incomplete Frame")
          break
        symbol_no_cp = self.__remove_cyclic_prefix(symbol)
        symbol_complex = self.__convert_complex(symbol_no_cp)
        symbol_demod = self.__fft(symbol_complex)
        symbol_binary = self.__fft_bins_to_binary(symbol_demod)

  # Load blocks of data into program, without loading entire file into memory
  def __each_frame(self, stream, separator):
    buffer = ''
    while True:  # until EOF
      frame = stream.read(self.Chunk_Size)
      if not frame:  # check EOF?
        yield buffer
        break
      buffer += frame
      while True:  # until no separator is found
        try:
          part, buffer = buffer.split(separator, 1)
        except ValueError:
          break
        else:
          if(part is ""):
            break
          yield part

  def __remove_cyclic_prefix(self, symbol):
    signal = symbol[int(self.CP):]
    return signal

  def __twos_comp(self, val):
    if (val & (1 << (16 - 1))) != 0: # if sign bit is set e.g., 8bit: 128-255
        val = val - (1 << 16)        # compute negative value
    return val   

  def __convert_complex(self, symbol):
    for index, each in enumerate(symbol):
      symbol.pop(index)
      real = self.__twos_comp(int(each[:16],2))
      # print(real)
      img = self.__twos_comp(int(each[16:],2))
      # print(img)
      complex_value = complex(real, img)
      # print(complex_value)
      symbol.insert(index, complex_value)
    complex_array = np.asarray(symbol)
    print(complex_array)
    return complex_array

  def __fft(self, symbol):
    return np.fft.fft(symbol)

  def __fft_bins_to_binary(self, symbol):
    for index, each in enumerate(symbol.real):
      # pass
      print(each)

rx = OFDM_RX()
rx.receive()






# # OFDM Receive (RX)

# OFDM_RX_noCP = OFDM_RX[int(CP):(int(CP+K))]

# # Compute FFT

# OFDM_demod = np.fft.fft(OFDM_RX_noCP)


# # ## Estimate RX channel
# # 
# # Following the FFT computation, the received channel must be estimated to estimate how the incoming signals map to their corresponding QAM symbol in the decoder. The receive channel suffers from decay in additive white noise as well as intersymbol interference. By utilising the pilot carriers placed into the TX message, the absolute value and phase of the TX message can be estimated.

# # In[103]:


# pilots = OFDM_demod[pilotCarriers]  # extract the pilot values from the RX signal
# H_est_at_pilots = pilots / P_Value # divide by the transmitted pilot values

# # Perform interpolation between the pilot carriers to get an estimate
# # of the channel in the data carriers. Now interpolation between the absolute value and phase 
# # can be performed separately
# H_est_abs = scipy.interpolate.interp1d(pilotCarriers, abs(H_est_at_pilots), kind='linear')(allCarriers)
# H_est_phase = scipy.interpolate.interp1d(pilotCarriers, np.angle(H_est_at_pilots), kind='linear')(allCarriers)
# H_est = H_est_abs * np.exp(1j*H_est_phase)

# plt.figure(5,figsize=(15,7))
# plt.plot(allCarriers, abs(H_exact), label='Correct Channel')
# plt.stem(pilotCarriers, abs(H_est_at_pilots), label='Pilot estimates')
# plt.plot(allCarriers, abs(H_est), label='Estimated channel via interpolation')
# plt.grid(True); plt.xlabel('Carrier index'); plt.ylabel('$|H(f)|$'); plt.legend(fontsize=10)
# plt.ylim(0,2)
# plt.show(block=False)


# # ## Equalise and retrieve payload

# # In[104]:


# equalized_H_est = OFDM_demod / H_est
# QAM_est = equalized_H_est[dataCarriers]

# plt.figure(6,figsize=(7,7))
# plt.plot(QAM_est.real, QAM_est.imag, 'go')


# # ## Demap symbols

# # In[105]:


# # generate demapping table and incoming symbol array
# demapping_table = {}
# constellation = np.array([])

# grey_code_list = grey_code(int(math.sqrt(MU)))
# for word in grey_code_list:
#     symbol = mod.modulate(word)
#     for each in symbol:
#         demapping_table[symbol[0]] = word
#         constellation = np.append(constellation, each)
#         each = np.vectorize(each)
                
# # calculate distance of each RX point to each possible point
# dists = abs(QAM_est.reshape((-1,1)) - constellation.reshape((1,-1)))

# # for each element in QAM, choose the index in constellation 
# # that belongs to the nearest constellation point
# const_index = dists.argmin(axis=1)

# # get back the real constellation point
# hardDecision = constellation[const_index]

# # transform the constellation point into the bit groups
# PS_est = np.vstack([demapping_table[C] for C in hardDecision])

# plt.figure(7,figsize=(7,7))
# for qam, hard in zip(QAM_est, hardDecision):
#     plt.plot([qam.real, hard.real], [qam.imag, hard.imag], 'g-o');
#     plt.plot(hardDecision.real, hardDecision.imag, 'bo')


# # ## Verify received bits and obtain BER
# # 
# # Finally, the decoded bits (RX) can be compared to the originally encoded bits and a bit error rate can be found. This is useful to observe when varying factors such as noise factor and the channel response.

# # In[106]:


# bits_est = PS_est.reshape((-1,))

# print("Obtained BER (Bit error rate): ", np.sum(abs(bits-bits_est))/len(bits))


# # ## Additional Learning
# # 
# # It's important to note that this example does not utilise any form of error correction encoding so any of the effects of the channel on the received message will show in the final decoding. Consider how error correction encoding could help to reduce the effects of noise and channel transmission on the received message.

# # #### References
# # 
# # - Channel Modelling - Haykin, S. (2016). Signals and systems. 2nd ed. United States: John Wiley, pp.78-80.
# # - OFDM Illustrations - http://dspillustrations.com/pages/posts/misc/python-ofdm-example.html