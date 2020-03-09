




open camaera / load video
--> captrue first frame --> image binaryzation (in RGB) 
--> extract armor light bars(recongnised in binarized mode)
--> select all the armor light bars
--> calcaulate distance between bars
--> output ceter coordinator

read in imgae /video --> 
				use cvtColor() && inrange() to initailly process the frame into binary image (white area is wanted)
				% using track_bars to manipulate  HSV parameters to find out intrested value intervals,
				 for black.PNG  H: O-255 ,S: 100-255, V:100-255
				 for black_full_bars_PNG: H: O-255 ,S: 0-255, V:100-255
				--->
				once determine the binary image, use erode() &&  dilate()
				% these two functions can further process the image with specific kernel
				 kernel is a Mat variable which can be initialized using getStructringElement()
				 eg: Mat kernel = getStructringElement(MORPH_RECT, Size(3, 3)), 
				 this command will create a rectangle kernel in size of (3,3), this kernel can be used to erode the traged image 
				 dilate() is the same as erode()
				--->
				adjust the HSV parameters using eroded and dilated resultant image (trackbars)
				--->
				findcontours() && drawcontrous(), these two functions will find and draw controus in targed HSV converted image
				---> approximate the contours to a certain ploygon eg: rectangle
				approxPolyDP() will approximate a certain contour to a certain polygon with a specified precision
				boundingRect() calculates and returns the minimal up-right bounding rectangle 
							   for the specified point set or non-zero pixels of gray-scale image.
				---> draw the boundingRect in contours
				rectangel() will draw rectangle using top-left and bottom-right coordinates
				