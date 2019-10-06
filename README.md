# Fixed-Point Viewer

This tool allows to view and convert floating data type to fixed-point data type or vice-versa.

![Preview of the tool](https://raw.githubusercontent.com/EmanuelFeru/FixedPointViewer/master/figures/example1.png)
 
The creation of this tool was triggered by my developments on [Field Oriented Control (FOC) for stock hoverboards](https://github.com/EmanuelFeru/hoverboard-firmware-hack-FOC) BLDC motors. The heart of the [hoverboard electronic circuit](https://raw.githubusercontent.com/EmanuelFeru/hoverboard-firmware-hack/master/pinout.png) is an [STM32F103RCT6](https://www.st.com/resource/en/datasheet/stm32f103vc.pdf) micro-controller with quite some capabilities however, it **lacks** the presence of a hardware **F**loating **P**oint **U**nit (FPU). The lack of this FPU made impossible the development of an FOC controller with floating point data types. Thus, full controller was developed in fixed point for more efficient calculations (check my other repo for details).

## What is fixed-point?

A [fixed point number format](https://en.wikipedia.org/wiki/Fixed-point_arithmetic) maps a real number onto an integer number by applying a fixed scaling to it. If for example you have real value 3.1415 and a fixed scaling of 100, the resulting integer value would be 3.1415 * 100 = 314. Reconstructing the real number from this value means applying the reverse operation: 314 / 100 = 3.14.

In practice the scaling values used are powers of 2 since multiplication and division by such values can be done by shift operations and shift operations are very efficient on most processor architectures. The advantage of fixed point numbers is that using them, under a certain set of rules, they allow for high performance math operations on processors that **lack** a hardware **F**loating **P**oint **U**nit (FPU). So, one of the main purposes of fixed point data representation is to be able to perform calculations efficiently without the need for expensive floating point conversions.

More details on fixed point data types can be found here:
- [Data Types and Scaling in Digital Hardware](https://nl.mathworks.com/help/fixedpoint/ug/data-types-and-scaling-in-digital-hardware.html)
- [Range and Precision](https://nl.mathworks.com/help/fixedpoint/ug/range-and-precision.html)


## SW Installation

1. Go to [FixedPointViewer\exe](https://github.com/EmanuelFeru/FixedPointViewer/tree/master/exe) and run 'FPViewer_setup.exe'
2. Follow the installation steps. 
3. Two SW components will be installed on your computer: the [Matlab Runtime](https://nl.mathworks.com/products/compiler/matlab-runtime.html) and the application itself. You will need both to run the application.
4. Once the installation is finished open the FPViewer app
5. Enjoy!


## How to use it

The tool usage is quite straight forward.  The tool works by:
1. Setting the fixed-point parameters in top-right
2. Then insert the correspondig float or fixed-point data to be converted
3. Finally, the data will be graphically displayed for better visualization

#### Fixed-point parameters
The parameters are in the form (**Sign**, **Word**, **Fraction**):

 - **Sign**: *1 (default) | 0* ► Sign specified as a boolean. A value of 1, indicates a signed data type. A value of 0 indicates an unsigned data type.
 - **Word length**: *16 (default) | scalar integer* ► Word length, in bits, specified as a scalar integer.
 - **Fraction length**: *4 (default) | scalar integer* ► Fraction length, in bits, specified as a scalar integer.

## Examples

The tool offers 2 examples:
  - **Example 1**: illustrates how to view and update a 2D surface map.
  - **Example 2**: illustrates how to view and update a 1D map.
