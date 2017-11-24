# IC_Lab

DFT

LFSR Generator implemented by Python for my friend ~

## 说明：

```
# include <stdint.h>
int main(void) {
    uint16_t seed = 0xACE1u;  /* 16位LFSR，seed是初始值 */ 
uint16_t lfsr = seed;
    do {
        unsigned valid = lfsr & 1;   /* LFSR序列不都是0 */
        lfsr >>= 1;                /* 移位 */
        if (valid)                 /* LFSR序列与16进制数B400按位异或*/
            lfsr ^= 0xB400u;
    } while (lfsr != seed);         /* LFSR序列与初始值相同时停止*/
    return 0;
}
```

此程序产生一个16位的伪随机数列。
重复44次（这个值要能够修改），产生一个704位的伪随机数列。
去掉4位（这个值要能够修改），得到一个700位的伪随机数列。

输出到文件中，格式为：

```
pattern = <pattern index>; /*从0开始编号*/
/* 空一行 */
<BitIndex> <BitValue> <BitIndex> <BitValue> ... <BitIndex> <BitValue> -1
/*如果第0位是1，第1位是1，第2位是0，那数列的样子是0 1 1 1 2 0 -1*/
```
（sample file里每个pattern有两个数列，我需要一个就可以了）

产生200个（这个值要能够修改）pattern（从0开始编号）

sample file：
```
pattern = 0;

0 0 1 0 2 1 3 1 4 1 5 0 6 1 -1
0 0 1 0 2 1 3 1 4 0 5 0 6 0 -1

pattern = 1;

0 1 1 0 2 1 3 1 4 1 5 0 6 0 -1

pattern = 2;

0 0 1 0 2 1 3 0 4 0 5 0 6 0 -1

pattern = 3;

0 0 1 1 3 1 4 0 5 0 -1
```
![][1]


  [1]: ./requirement.png