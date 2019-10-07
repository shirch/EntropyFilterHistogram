# EntropyFilterHistogram
CPU Architecture, FPGA, Quartus, MIPS

## Aim of the Assignment
• Design, synthesize and analyze a digital filter.

• Understanding FPGA memory structure
## Definition and prior knowledge
The aim of this laboratory is to design a Real Time entropy detection filter for an
image received from a camera. The histogram of the image must be calculated.
Further information will be given below.
## Assignment definition
 You must design an entropy filter and image histogram. Connect both modules to
MIPS MCU, which was designed in previous work.
While performing the RT image processing the MIPS CPU must continue to work (run a
program). The PLL [2] is used to make a higher frequency from the 50MHz clock and is
used in FPGA compilation only.

You have to do the following tasks:

• Modelsim Simulation with maximal coverage

• Quartus Compilation

• Find the maximum operating clock

• Analyze the critical path, and explain what is the main reason

• Analyze the logic usage, and optimize it for FPGA

• Load the design into the FPGA and verify the simulation results

The following must be presented in the report:

• RTL Viewer results for each logic block

• Logic usage for each block (Combinational and Flip-Flops)

• Critical path for each logic block and overall system critical path

• Optimizations performed on the code for the FPGA

• Logic usage report from Quartus II
## Test
As a test bench, you will have to perform an entropy filter [1],[6] on the image taken
from camera. The size of the filter will be 6x6. In addition to the filtering process, the
image histogram [5] will be calculated. Switches will allow to select the image presented
on the monitor (original, filtered or histogram). 

The test will be in the following steps:

• Capture image from camera, convert to gray scale.

• MCU Receive interrupt from the camera when a frame is saved into memory.

• Send command to hardware to perform the filtering or histogram calculation.

• Receive interrupt when hardware done and filtered frame saved into memory

• An original image, filtered image or histogram will be presented on monitor
depending on switches.

• MCU must run counter in main loop and print to 7S the time in resolution of seconds.

You must compare processing time of entropy filter and histogram in hardware design vs
implementation in MIPS from lab3 (theoretically) and provide an estimation of the
speedup. If necessary, instructions can be added to your MIPS design. 
