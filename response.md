### Assess the response of the kernel
```matlab
% add package to path
addpath('.\src\')

% Assess the kernel in the time domain with
artacs.kernel.response(kernel,1)

% Assess the magnitude response with
foi = 1:30;         %frequencies of interest
foi = [1,30];       %frequency of interest band boundaries
foi = 30;           %upper frequency of interest
artacs.kernel.response(kernel,2,foi)
```
## Time Response

#### Causal
<table>
<tr>
<th><img src="docs\img\causal\kernel_ave.png" width = "400"></th>
<th><img src="docs\img\causal\kernel_linear.png" width = "400"></th>
<th><img src="docs\img\causal\kernel_exp.png" width = "400"></th>
<th><img src="docs\img\causal\kernel_gauss.png" width = "400"></th>
</tr>
<tr>
<th><center>Uniform / Average</center></th>
<th><center>Linear</center></th>
<th><center>Exponential</center></th>
<th><center>Gaussian</center></th>
</tr>
</table>

#### Symmetric

<table>
<tr>
<th><img src="docs\img\sym\kernel_ave.png" width = "400"></th>
<th><img src="docs\img\sym\kernel_linear.png" width = "400"></th>
<th><img src="docs\img\sym\kernel_exp.png" width = "400"></th>
<th><img src="docs\img\sym\kernel_gauss.png" width = "400"></th>
</tr>
<tr>
<th><center>Uniform / SMA</center></th>
<th><center>Linear</center></th>
<th><center>Exponential</center></th>
<th><center>Gaussian</center></th>
</tr>
</table>

## Frequency Response

#### Causal
<table>
<tr>
<th><img src="docs\img\causal\mag_ave.png" width = "400"></th>
<th><img src="docs\img\causal\mag_linear.png" width = "400"></th>
<th><img src="docs\img\causal\mag_exp.png" width = "400"></th>
<th><img src="docs\img\causal\mag_gauss.png" width = "400"></th>
</tr>
<tr>
<th><center>Uniform / Average</center></th>
<th><center>Linear</center></th>
<th><center>Exponential</center></th>
<th><center>Gaussian</center></th>
</tr>
</table>

#### Symmetric

<table>
<tr>
<th><img src="docs\img\sym\mag_ave.png" width = "400"></th>
<th><img src="docs\img\sym\mag_linear.png" width = "400"></th>
<th><img src="docs\img\sym\mag_exp.png" width = "400"></th>
<th><img src="docs\img\sym\mag_gauss.png" width = "400"></th>
</tr>
<tr>
<th><center>Uniform / SMA</center></th>
<th><center>Linear</center></th>
<th><center>Exponential</center></th>
<th><center>Gaussian</center></th>
</tr>
</table>
