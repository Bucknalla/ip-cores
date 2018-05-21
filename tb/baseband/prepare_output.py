import math, os

def convert_binary():
    if (os.stat("output.bin").st_size == 0):
        print("")
    try:
        with open("output.bin","r") as file:
            with open("decimal.bin", "w") as target:
                for index, x in enumerate(file):
                    if((index % 512) is 0):
                        target.write("\n")
                    data = int(x, 2)
                    print(data)
                    target.write(str(data)+"\n")
    except IOError as e:
        print(e.args[1])
    

        

if __name__ == '__main__':
    convert_binary()