.PHONY : all clean

all: generate_binary convert-decimal

generate_binary:
	python generate_binary.py

convert-decimal:
	python convert_binary.py

clean-conversion:
	rm decimal.bin && touch decimal.bin

clean: 
	> *.bin