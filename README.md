## To Do



## Reconstruction
### Possible reconstructors  to use and reference. 
2. `AMP` in  `CS_1D_Demo`.
3. `cvx_begin` in `lec6L1vsL2.m`.
4. `simcosamp` in `lec7ToyExample`. 
5. `l1eq_pd` in `compressed_sensing_example`.
6. `spgl1` in `RecFullImageFromCompImage`.

 Implemment some form this thesis [[Graeme2009Compressive]].

## Questions
1. Why no transform domain in DAMP?
2. M-AMP and Others ALGO WORKING 







### Till 21 July


## Following [Naushad_TIP2017](https://in.mathworks.com/matlabcentral/fileexchange/62713-naushad_tip2017) from this [paper](https://doi.org/10.1109/TIP.2017.2700719).


### Main Dependencies:
#### 1. [Sparco](https://github.com/MPF-Optimization-Laboratory/Sparco)

1. [Manuals: Sparco: A Testing Framework for Sparse Reconstruction](https://personal.math.ubc.ca/~oyilmaz/preprints/sparco.pdf)
2. [Blog: SPARCO
](https://friedlander.io/software/sparco/)

##### Sparco Dependencies:

1. [Rice Wavelet Toolbox](https://github.com/ricedsp/rwt)
2. [CurveLab](http://www.curvelet.org/)

##### Sparco Issues

1. Issues in `opWavelet2`
2. Not installed [fftw](https://www.fftw.org/) needed for calling `fdct_wrapping_mex` in `CurveLab`.


#### 2. [SPGL1](https://friedlander.io/spgl1/)

#### 3. [Spot – A Linear-Operator Toolbox](https://github.com/mpf/spot)

[A Quick Guide to Using Spot](https://www.cs.ubc.ca/labs/scl/spot/guide_quick2.html)


#### Other Reference

1. [Demo3](http://dgci2014.diism.unisi.it/demos/demo3.pdf)


## Naushad_TIP2017 seems to be too slow. 

Thus following [ABCS](https://doi.org/10.1109/ACCESS.2020.3006861)

### Main Dependencies:

1. [D-AMP Toolbox](https://github.com/ricedsp/D-AMP_Toolbox)

