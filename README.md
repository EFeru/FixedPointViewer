---


---

<hr>
<hr>
<h1 id="fixed-point-viewer">Fixed-Point Viewer</h1>
<p>This tool allows to view and convert float data type to fixed-point data type or vice-versa. With this tool the user can view and convert fixed-point data types.</p>
<p><img src="https://raw.githubusercontent.com/EmanuelFeru/FixedPointViewer/master/figures/example1.png" alt="Preview of the tool"></p>
<p>The creation of this tool was triggered by my developments on Field Oriented Control (FOC) for on stock hoverboards BLDC motors. The hoverboard heart is an STM32F103RCT microcontroller with quite some capabilitie however, without a Floating Point Unit (FPU). The lack this FPU made impossible the development of an FOC controller with floating point data type. Thus, full controller was converted to fixed point types (check my other repo for details).</p>
<h2 id="what-is-fixed-point">What is fixed-point?</h2>
<p>A fixed point number format maps a real number onto an integer number by applying a fixed scaling to it. If for example you have real value 3.1415 and a fixed scaling of 100, the resulting integer value would be 3.1415 * 100 = 314. Reconstructing the real number from this value means applying the reverse operation: 314 / 100 = 3.14.</p>
<p>In practice the scaling values used are powers of 2 since multiplication and division by such values can be done by shift operations and shift operations are very efficient on most processor architectures. The advantage of fixed point numbers is that using them, under a certain set of rules, they allow for high performance math operations on processors that lack a hardware floating point unit (FPU). So, one of the main purposes of fixed point data representation to be able to perform calculations efficiently without the need for expensive floating point conversions.</p>
<p>More details on fixed point data types can be found here:<br>
<a href="https://nl.mathworks.com/help/fixedpoint/ug/data-types-and-scaling-in-digital-hardware.html">Data Types and Scaling in Digital Hardware</a><br>
<a href="https://nl.mathworks.com/help/fixedpoint/ug/range-and-precision.html">Range and Precision</a></p>
<h2 id="sw-installation">SW Installation</h2>
<ol>
<li>Go to ‘FixedPointViewer\exe’ and run ‘FPViewer_setup.exe’</li>
<li>Follow the installation steps.</li>
<li>Two SW components will be installed on your compoter the Matlab Runtime and the application itself. You will need both to run the application.</li>
<li>Once the installation is finished open the FPViewer app</li>
<li>Enjoy!</li>
</ol>
<h2 id="how-to-use-it">How to use it</h2>
<p>The tool usage is quite straight forward.  The tool works by:</p>
<ol>
<li>Setting the fixed-point parameters in top-right</li>
<li>Then insert the corresponding float or fixed-point data to be converted</li>
<li>Finally, the data will be graphically displayed for better visualization</li>
</ol>
<p><strong>Fixed-point parameters</strong><br>
The parameters are in the form (<strong>Sign</strong>, <strong>Word</strong>, <strong>Fraction</strong>):<br>
• <strong>Sign</strong>: <em>1 (default) | 0</em><br>
Sign specified as a Boolean. A value of 1, indicates a signed data type. A value of 0 indicates an unsigned data type.<br>
• <strong>Word length</strong>: <em>16 (default) | scalar integer</em><br>
Word length, in bits, specified as a scalar integer.<br>
• <strong>Fraction length</strong>: <em>4 (default) | scalar integer</em><br>
Fraction length specified as a scalar integer.</p>
<h2 id="examples">Examples</h2>
<p>The tool offers 2 examples:<br>
• <strong>Example 1</strong>: illustrates how to view and update a 2D surface map.<br>
• <strong>Example 2</strong>: illustrates how to view and update a 1D map.</p>

