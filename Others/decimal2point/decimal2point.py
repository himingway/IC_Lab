#!/usr/bin/env python

import re
import sys

def read_number():
	s = input("Please input the number you want to convert (.eg 0.299): ")
	m1 = re.match("(0|[1-9]+)\.[0-9]+",s)
	if m1 is not None:
		print("The number you input is: ", s)
		n = input("Please input the precision(.eg 10): ")
		m2 = re.match("[0-9]+",n)
		if m2 is not None:
			print("The precision you input is: ", n)
			return s,n
		else:
			print("Please input the correct precision")
			sys.exit()
	else:
		print("Please input the correct decimal number")
		sys.exit()

def decimal2point(s,n):
	decimal2bin = ""
	integer, decimal = s.split(".")
	decimal = float('0.'+ decimal)
	integer2bin = bin(int(integer,10)).replace('0b','')
	for i in range(int(n)):
		decimal = decimal * 2.0
		if(decimal >= 1.0):
			decimal2bin = decimal2bin + '1'
			decimal = decimal - 1;
		else:
			decimal2bin = decimal2bin + '0'
	print ("")
	print ("Out(binary):")
	print (integer2bin+'.'+decimal2bin)
	print ("Out(integer):")
	if (integer == "0"):
		print (str(int(decimal2bin,2))+"/"+str(2**int(n)))
	else:
		print (str(int(integer2bin,2))+"┐"+str(int(decimal2bin,2))+"/"+str(2**int(n)))

if __name__ == '__main__':
	s,n = read_number()
	decimal2point(s,n)