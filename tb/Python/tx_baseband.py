import numpy as np

import commpy as cp
import scipy.interpolate
import matplotlib.pyplot as plt
import math

# Configure Variables

K = 64 # Number of OFDM subcarriers
CP = K * 0.25 # Length of the cyclic prefix: % of the block
P = 8 # Number of pilot carriers per OFDM block
P_Value = 3+3j # The known complex value each pilot transmits
MU = 16 # Number of bits per symbol (i.e. 16QAM) - NOTE: Must have integer sqrt(MU) 

# Generating carriers

allCarriers = np.arange(K)  # indices of all subcarriers ([0, 1, ... K-1])
pilotCarriers = allCarriers[::K // P] # Pilots is every (K/P)th carrier.
pilotCarriers = np.hstack([pilotCarriers, np.array([allCarriers[-1]])]) # Make the last carriers also pilots
# P = P + 1
dataCarriers = np.delete(allCarriers, pilotCarriers) # All remaining carriers are data carriers

print ("Total Available Carriers: \n %s" % allCarriers)
print ("\nPilot Carriers: \n %s" % pilotCarriers)
print ("\nData Carriers: \n %s" % dataCarriers)

plt.figure(1,figsize=(18,1.2))
plt.title('Carrier Distribution')
plt.plot(pilotCarriers, np.zeros_like(pilotCarriers), 'bo', label='pilot')
plt.plot(dataCarriers, np.zeros_like(dataCarriers), 'go', label='data')
plt.legend(fontsize=10, ncol=2)
plt.xlim((-1,K)); plt.ylim((-0.1, 0.3))
plt.xlabel('Carrier index')
plt.yticks([])
plt.grid(True)


# Generating grey code for QAM constellations

def grey_code(n):
   def grey_code_recurse(g, n):
       k = len(g)
       if n <= 0:
           return
       else:
           for i in range (k-1, -1, -1):
               char = '1'+g[i]
               g.append(char)
           for i in range (k-1, -1, -1):
               g[i] = '0'+g[i]
           grey_code_recurse (g, n-1)
   g = ['0', '1']
   grey_code_recurse(g, n-1)
   g_new = []
   for word in g:
       word_new = []
       for bit in word:
           word_new.append(int(bit))
       word_new = tuple(word_new)
       g_new.append(word_new)
   return g_new


# Generating the QAM constellation

log2mu = int(np.log2(MU))
log2mu2 = (log2mu+1)

payloadBits_per_OFDM = len(dataCarriers)*log2mu  # number of payload bits per OFDM symbol

mod = cp.modulation.QAMModem(MU)

plt.figure(2,figsize=(7,7))
plt.title("Constellation Diagram of QAM "+str(MU))

grey_code_list = grey_code(int(math.sqrt(MU)))
for word in grey_code_list:
    symbol = mod.modulate(word)
    for each in symbol:
        each = np.vectorize(each)
    plt.plot(symbol.real, symbol.imag, 'bo')
    plt.text(symbol.real, symbol.imag+0.2, "".join(str(x) for x in word), ha='center')
    
plt.grid(True)
plt.xlim((-(log2mu2), (log2mu2))); plt.ylim((-(log2mu2),(log2mu2))); plt.xlabel('Real part (I)'); plt.ylabel('Imaginary part (Q)')
plt.show(block=False)


# Modelling RF channel response

channelResponse = np.array([1, 0, 0.4+0.4j])  # the impulse response of the wireless channel
H_exact = np.fft.fft(channelResponse, K)

plt.figure(3,figsize=(15,7))
plt.title("Impulse Response of Channel")
plt.plot(allCarriers, abs(H_exact))
plt.xlabel('Subcarrier index'); plt.ylabel('$|H(f)|$'); plt.grid(True); plt.xlim(0, K-1)

SNRdb = 25  # signal to noise-ratio in dB at the receiver 


# Generating a transmission bitstream

bits = np.random.binomial(n=1, p=0.5, size=(int(payloadBits_per_OFDM), ))

print ("Number of bits: ", len(bits))
print ("\nFirst 20 bits: ", bits[:20])
print ("\nMean of bits (approx 0.5): ", np.mean(bits))

# Convert bits from serial to parallel

bits_SP = bits.reshape((len(dataCarriers), int(np.log2(MU))))

print ("First 5 bit groups : \n\n", bits_SP[:5,:])


# Map bitstream to QAM symbols

QAM = np.array([mod.modulate(tuple(b)) for b in bits_SP])
QAM = QAM.flatten()

print ("First 5 QAM symbols : \n\n", QAM[:5])


# Allocate QAM symbols to carriers

symbol = np.zeros(K, dtype=complex) # the overall K subcarriers
symbol[pilotCarriers] = P_Value  # allocate the pilot subcarriers 
symbol[dataCarriers] = QAM  # allocate the pilot subcarriers
OFDM_data = symbol

print("First 5 frequency bin values : \n\n", OFDM_data[:5])
print ("\nNumber of OFDM carriers in frequency domain: ", len(OFDM_data))


# Compute IFFT and convert freq. bins to time domain

OFDM_time = np.fft.ifft(OFDM_data)

print ("First 5 time domain samples after IFFT: \n\n", OFDM_time[:5])
print ("\nNumber of OFDM samples in time domain before CP: ", len(OFDM_time))


# Apply cyclic prefix to time domain signal

cp = OFDM_time[-(int(CP)):] # Take the last CP samples ...
OFDM_withCP = np.hstack([cp, OFDM_time]) # Add CP samples back to to the beginning

print ("Number of OFDM samples in time domain after CP: ", len(OFDM_withCP))


# Apply noise and simulate channel response

SNRdb = 25  # signal to noise-ratio in dB at rx; larger the value, the more clearly received the signal will be 

# Calculate output signal as well as signal & noise power.

convolved = np.convolve(OFDM_withCP, channelResponse) # Received signal is expressed as a convolution of the channel and the input signal
signal_power = np.mean(abs(convolved**2))
sigma2 = signal_power * 10**(-SNRdb/10)  # calculate noise power based on signal power and SNR

print ("RX Signal power: %.4f. Noise power: %.4f" % (signal_power, sigma2))

# Generate complex noise with given variance
noise = np.sqrt(sigma2/2) * (np.random.randn(*convolved.shape)+1j*np.random.randn(*convolved.shape))

OFDM_TX = OFDM_withCP
OFDM_RX = convolved + noise

plt.figure(4,figsize=(20,7))
plt.title('TX & RX Channels in Time Domain')
plt.plot(abs(OFDM_TX), label='TX signal')
plt.plot(abs(OFDM_RX), label='RX signal')
plt.legend(fontsize=10)
plt.xlabel('Time Interval'); plt.ylabel('$|x(t)|$')
plt.grid(True)


