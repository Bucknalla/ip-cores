import numpy as np
import commpy as cp
import scipy.interpolate
import matplotlib.pyplot as plt
import math, os

# Configure Script Variables

frame_SIZE = 4096 # In bytes

# Configure OFDM Variables

K = 512 # Number of OFDM subcarriers
CP = K * 0.25 # Length of the cyclic prefix: % of the block
P = 8 # Number of pilot carriers per OFDM block
P_Value = 3+3j # The known complex value each pilot transmits
MU = 16 # Number of bits per symbol (i.e. 16QAM) - NOTE: Must have integer sqrt(MU) 
Pr = 32 # Number of preamble carriers
Pr_Value = 1+1j # 
Frame_Size = K + P + Pr

# Load bits into flow without loading entire file into memory

def each_frame(stream, separator):
  buffer = ''
  while True:  # until EOF
    frame = stream.read(frame_SIZE)
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
        yield part

def prepare_ofdm_symbol():
  if (os.stat("output.bin").st_size == 0):
      print("Please run testbench to generate output.bin")
  try:
      with open("output.bin","r") as file:
          with open("symbols.bin", "w") as target:
              for index, data in enumerate(file):
                if((index % Frame_Size) is 0):
                    target.write("-\n")
                target.write(str(data))

  except IOError as e:
      print(e.args[1])

# def validate_complete_frame(frame):
#   for each in 

def load_ofdm_symbol(binaryname):
  with open(binaryname) as binary:
    for index, frame in enumerate(each_frame(binary, separator='-')):
      print(len(frame))
      print("OFDM Frame: "+str(index))
      # print(frame)  # not holding in memory, but loading one frame at a time
      frame = frame.split("\n")
      print(frame)
      print()
      # frame.remove("") # remove empty packets
      # frame = list(filter(None, frame))
      # for index, each in enumerate(frame):
      #   print("-{}-".format(each))
      #   frame.pop(index)
      #   print("{0}: {1}".format(index, each))
      #   real = each[:16]
      #   img = each[16:]
      #   print("img: {0} | real: {1}".format(img,real))



      
prepare_ofdm_symbol()
load_ofdm_symbol("symbols.bin")














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