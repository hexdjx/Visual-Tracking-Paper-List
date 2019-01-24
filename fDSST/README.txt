This MATLAB code implements the Fast Discriminative Scale Space Tracker (fDSST) [1], which is an extension of the VOT2014 winning DSST tracker [2]. The code provided by [3] is used for computing the HOG features.

The project website is:
http://www.cvl.isy.liu.se/research/objrec/visualtracking/index.html

Installation:
To be able to run the "mexResize" function, try to use either one of the included mex-files or compile one of your own. OpenCV is needed for this. The existing compile scripts "compilemex.m" or "compilemex_win.m" can be modified for this purpose.

Instructions:
1) Run the "run_tracker.m" script in MATLAB.
2) Choose sequence (only "dog1" is included).

Contact:
Martin Danelljan
martin.danelljan@liu.se
http://users.isy.liu.se/cvl/marda26/


[1]	Martin Danelljan, Gustav Häger, Fahad Khan, Michael Felsberg. 
	Discriminative Scale Space Tracking.
	Transactions on Pattern Analysis and Machine Intelligence (TPAMI). 

[2] Martin Danelljan, Gustav Häger, Fahad Shahbaz Khan and Michael Felsberg.
    "Accurate Scale Estimation for Robust Visual Tracking".
    Proceedings of the British Machine Vision Conference (BMVC), 2014.

[3] Piotr Dollár.
    "Piotr’s Image and Video Matlab Toolbox (PMT)."
    http://vision.ucsd.edu/~pdollar/toolbox/doc/index.html.