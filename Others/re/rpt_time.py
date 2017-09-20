import sys
import re

def read_txt(path):
    try:
        with open(path, 'r') as f:
            lines = f.readlines()
            line_num = len(lines)
            # print(lines)
            # print(line_num)
        return lines, line_num
    except:
        print("Input File Error")

def anylize(line):
    i = 0
    clock = 0
    lib_time = 0
    first_line = []
    last_line = []
    for s in line :
        r1 = re.search(r'Point(\s){0,}Incr(\s){0,}Path',s)
        if r1 is not None:
            first_line.append(i)
        r2 = re.search(r'(data arrival time)', s)
        if r2 is not None:
            last_line.append(i)
        r3 = re.search(r'clock network delay', s)
        if r3 is not None:
            clock = s.split()
        r4 = re.search(r'library setup time', s)
        if r4 is not None:
            lib_time = s.split()
            # print(clock[-1])
        i = i + 1
    return first_line[0]+2,last_line[0],clock[-1],lib_time[-2]


def cal_path_time(line, first_line, last_line):
    sum = 0
    line = line[first_line:last_line]
    # for i in range(len(line)):
    #     print(line[i])
    for i in line:
        line_split = i.split()
        if(line_split[-1]) not in ['r','f']:
            line_split.append('f')
        # print (line_split)
        sum = sum + float(line_split[-3])
      #  print('%.2f' % sum)
    return sum

if __name__ == '__main__':
    line,line_num = read_txt(sys.argv[1])
    first_line,last_line,clock,lib_time = anylize(line)
    path_time = cal_path_time(line,first_line,last_line)
    print('clock period = %.2f' %float(clock))
    print('library setup time = %.2f' %float(lib_time))
    print('date arrival time = %.2f' %path_time)
    slack = float(clock) - float(lib_time) - path_time
    if(slack >= 0):
        print('slack(MET) = %.2f' %slack)
    else:
        print('slack(Not Met) = %.2f' %slack)