import math

def generate_binary(n):
    with open("data.bin","w") as file:
        for x in range(0, (2 ** n)):
            data = format(x, '032b')+"\n"
            print(data)
            file.write(data)
        

if __name__ == '__main__':
    generate_binary(16)