#!/usr/bin/env python
import random

N = input("重复个数:\n")
M = input("去掉位数:\n")
P = input("Pattern 数\n")
f = open('out.txt', 'wt')

def bin_format(lfsr):
    if (len(lfsr) < 16):
        for j in range(16 - len(lfsr)):
            lfsr = '0' + lfsr
    return lfsr

def generate_lfsr (N, P):
    out_list = ['' for n in range(65535)]
    for n in range (int(N)):
        seed = random.randrange(1,65535) #随机种子
        print("产生的随机种子:","0x%.4X" %seed)
        lfsr = seed
        temp = []
        for p in range(int(P)):
            valid = lfsr & 1
            lfsr >>= 1
            if (valid):
                lfsr ^= 0xB400
            lfsr_bin = bin(lfsr).replace('0b','')
            temp.append(bin_format(lfsr_bin))
        out_list = list(map(lambda x, y: x + y, temp, out_list))
    return out_list

def print_out (lfsr_list, N, M, f):
    pattern = 0
    for lfsr in lfsr_list:
        print("pattern = %d;" % pattern, file=f)
        print("", file=f)
        for index in range(len(lfsr) - int(M)):
            print(index,lfsr[index],'',end='',file=f),
        print(-1,file=f)
        print("",file=f)
        pattern += 1

lfsr_list = generate_lfsr(N,P)
print_out(lfsr_list,N,M,f)
f.close()