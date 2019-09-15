# Fixed-Point Viewer

This tool allows to view and convert float data type to fixed-point data type or vice-versa. With this tool the user can view and convert fixed-point data types.

![Preview of the tool]([https://raw.githubusercontent.com/EmanuelFeru/FixedPointViewer/master/figures/example1.png](https://raw.githubusercontent.com/EmanuelFeru/FixedPointViewer/master/figures/example1.png)
 
The creation of this tool was triggered by my developments on Field Oriented Control (FOC) for BLDC motors on stock hoverboards. The hoverboard heart is an STM32F103RCT microcontroller with quite some capabilitie however, without a Floating Point Unit (FPU). The lack this FPU made impossible the development of an FOC controller with floating point data. Thus, full controller was converted to fixed point (check my other repo for details).

## What is fixed-point?

A fixed point number format maps a real number onto an integer number by applying a fixed scaling to it. If for example you have real value 3.1415 and a fixed scaling of 100, the resulting integer value would be 3.1415 * 100 = 314. Reconstructing the real number from this value means applying the reverse operation: 314 / 100 = 3.14.

In practice the scaling values used are powers of 2 since multiplication and division by such values can be done by shift operations and shift operations are very efficient on most processor architectures. The advantage of fixed point numbers is that using them, under a certain set of rules, they allow for high performance math operations on processors that lack a hardware floating point unit (FPU). So, one of the main purposes of fixed point data representation to be able to perform calculations efficiently without the need for expensive floating point conversions.

More details on fixed point data types can be found here:
![Data Types and Scaling in Digital Hardware](https://nl.mathworks.com/help/fixedpoint/ug/data-types-and-scaling-in-digital-hardware.html)
![Range and Precision](https://nl.mathworks.com/help/fixedpoint/ug/range-and-precision.html)


## SW Installation
---

1. Go to 'FixedPointViewer\exe' and run 'FPViewer_setup.exe'
2. Follow the installation steps. 
3. Two SW components will be installed on your compoter the Matlab Runtime and the application itself. You will need both to run the application.
4. Once the installation is finished open the FPViewer app
5. Enjoy!


## How to use it
---

The tool usage is quite straight forward.  The tool works by:
1. Setting the fixed-point parameters in top-right
2. Then insert the correspondig float or fixed-point data to be converted
3. Finally, the data will be graphically displayed for better visualization

### Fixed-point parameters
The parameters are in the form (Sign, Word, Fraction):
• Sign: 1 (default) | 0
 Sign specified as a boolean. A value of 1, indicates a signed data type. A value of 0 indicates an unsigned data type.
• Word length: 16 (default) | scalar integer
Word length, in bits, specified as a scalar integer.
• Fraction length: 4 (default) | scalar integer
Fraction length specified as a scalar integer.

## Examples
---

The tool offers 2 examples:
 • Example 1: illustrates how to view and update a 2D surface map.
 • Example 2: illustrates how to view and update a 1D map.

<!--stackedit_data:
eyJoaXN0b3J5IjpbMjA4ODczNDg1MV19
-->