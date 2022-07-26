### Sampler
1. `Sampler` should be contionous instead of `randn` in `CS_Imaging_Demo`.

### Key Issues:
1. How to convert spiral curve into a matrix so that when multipled with image it contains pixel value along that spiral curve.
2. Then, if the image being vectorised `img1(:)`. How will it affect the matrix?
3. How this will change if the size of the image changes?

### Reference
1. [ROI-Based Processing](https://in.mathworks.com/help/images/roi-based-processing.html?s_tid=CRUX_lftnav)
2. [Polyline](https://in.mathworks.com/help/images/ref/images.roi.polyline.html)
3. [https://in.mathworks.com/help/images/create-binary-mask-using-an-roi-object.html](https://in.mathworks.com/help/images/create-binary-mask-using-an-roi-object.html)

### Approach:
1. Strat to use `improfile()` & `drawline()` for lines.
2. Then, Proceed with curves.

### Reference
1. Access to pixels along the curve/path using opencv
2. 