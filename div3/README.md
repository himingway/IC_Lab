*The Art of Hardware Architecture* P88 ~ P89

STEP I: Create a counter that counts from 0 to (N - 1) and always clocks on therising edge of the input clock where N is the natural number by which theinput reference clock is supposed to be divided (N != Even).

STEP II: Take two toggle flip-flops and generate their enables as follows: 
* tff1_en: TFF1 enabled when the counter value = 0
* tff2_en: TFF2 enabled when the counter value = (N + 1) / 2. 

STEP III: Generate the following signals.
* div1: output of TFF1 -> triggered on rising edge of input clock (ref_clk)
* div2: output of TFF2 -> triggered on falling edge of input clock (ref_clk)

The code has been verified using Fpga Gate Simulator.