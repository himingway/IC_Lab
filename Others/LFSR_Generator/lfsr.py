#!/usr/bin/env python
import random

Len = 24 #长度
Mask = '0xB400' #异或的数
P = 5  #Pattern数
Mode = 2
f = open('out.txt', 'wt')

N = int(Len/(2**(len(Mask)-2))+1)
M = int(N * (2**(len(Mask)-2)) - Len)

def bin_format(lfsr):
    if (len(lfsr) < 2**(len(Mask)-2)):
        for j in range(2**(len(Mask)-2) - len(lfsr)):
            lfsr = '0' + lfsr
    return lfsr

def generate_lfsr (N, P):
    out_list = ['' for n in range(P)]
    for n in range (N):
        seed = random.randrange(1,2**(4*(len(Mask)-2))) #随机种子
        print("产生的随机种子:","0x%.4X" %seed)
        lfsr = seed
        temp = []
        for p in range(P):
            valid = lfsr & 1
            lfsr >>= 1
            if (valid):
                lfsr ^= int(Mask,16)
            lfsr_bin = bin(lfsr).replace('0b','')
            temp.append(bin_format(lfsr_bin))
        out_list = list(map(lambda x, y: x + y, temp, out_list))
    return out_list

def print_out (lfsr_list, M, f):
    pattern = 0
    for lfsr in lfsr_list:
        print("pattern = %d;" % pattern, file=f)
        print("", file=f)
        for index in range(len(lfsr) - M):
            print(index,lfsr[index],'',end='',file=f),
        print(-1,file=f)
        for index in range(len(lfsr) - M):
            print(index,lfsr[index],'',end='',file=f),
        print(-1,file=f)
        print("",file=f)
        pattern += 1

def print_out_1 (lfsr_list, M, f):
    pattern = 0
    for lfsr in lfsr_list:
        print("pattern = %d;" % pattern, file=f)
        print("", file=f)
        for index in range(0,len(lfsr) - M,2):
            print(int(index/2),int(lfsr[index-1]) & int(lfsr[index]),'',end='',file=f),
        print(-1,file=f)
        for index in range(0,len(lfsr) - M,2):
            print(int(index/2),int(lfsr[index-1]) & int(lfsr[index]),'',end='',file=f),
        print(-1,file=f)
        print("",file=f)
        pattern += 1

def print_out_2 (lfsr_list, M, f):
    pattern = 0
    for lfsr in lfsr_list:
        print("pattern = %d;" % pattern, file=f)
        print("", file=f)
        for index in range(1,len(lfsr) - M,2):
            print(int(index/2),int(lfsr[index-1]) ^ int(lfsr[index]),'',end='',file=f),
        print(-1,file=f)
        for index in range(1,len(lfsr) - M,2):
            print(int(index/2),int(lfsr[index-1]) ^ int(lfsr[index]),'',end='',file=f),
        print(-1,file=f)
        print("",file=f)
        pattern += 1

lfsr_list = generate_lfsr(N,P)
if Mode == 0:
    print_out(lfsr_list,M,f)
elif Mode == 1:
    print_out_1(lfsr_list, M, f)
elif Mode == 2:
    print_out_2(lfsr_list, M, f)
else:
    print("default mode")
    print_out(lfsr_list, M, f)

f.close()