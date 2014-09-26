CV HW 5 
Linxi Fan
lf2422

All the scripts run successfully in Matlab. 
The codes are heavily commented for TA's convenience.

=============== Challenge 1 ===============
I use the function normxcorr2() to do the template matching. This can be
much faster than a double for-loop with corr2().

It is very tricky to match the template close to the image boundary. My
algorithm takes special care of these cases. 

On top of the brute-force search, I impose a few filtering rules to make the
optical flow more robust.
For example, any flow vector that has length greater than a certain
(variable) threshold will be ruled out. 

This is why you see less noise (random arrows) in the area where there's very 
few texture (e.g. the black region at the bottom right). 
In this way, the annotated image looks much better.

I experimented with a very dense field and saved the results to
the folder "flow_result". The flow field looks highly smooth and robust. 
The screenshots are taken manually for better resolution. 

The script saves the annotated screen with the function 'saveAnnotatedImg'
we used before. The output file names are "result_<i>_<i+1>.png".

The actual grid density I set in runHw5.m is lowered for speed. It takes
around 30 seconds to render 5 annotated images on my laptop. 

- Debug1a
Parameters: 
search_half_window_size = 10;
template_half_window_size = 4;
grid_MN = [32, 24];

- Challenge1a
search_half_window_size = 10;
template_half_window_size = 15;
grid_MN = [32, 24]; 


=============== Challenge 2 ===============
The object tracker works really well on all three data sets.

The annotated image sequences are saved to "*_result" folders.

I modified the trackingTester() signature slightly. Now it takes a third
boolean argument. If true, it uses imshow() to display the annotated image
stack. If false, it silently saves the results to disk. 

The best number of histogram bins is found to be around 16 to 24. 

Note that the box I use is smaller than the bounding box that wraps the
entire object. This makes the tracking much more robust. 
In the "basketball" data set, the tracer does not lose its target when the two
green players overlap (frame 177). 


=============== Thank you ===============
This is the last assignment of the semester. As is always the case in life,
things always come to an end no matter how much fun I had. 

To tell the truth, the Computer Vision class has been THE BEST course I've
ever taken in the CS department. The coolest professor and the chillest TAs,
unequivocally. I learned and enjoyed much more than I expected. 

Thank you all for this wonderful experience. I will most likely pursue a career
in computer vision, and CS4731 has marked an unforgettable beginning of a long and exciting journey. 

See you soon. 
