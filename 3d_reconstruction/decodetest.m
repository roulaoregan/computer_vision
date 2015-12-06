imageprefix = 'C:/Users/Roula/Documents/MATLAB/Assignment_4/left/left/left_';
threshold = 5;
start = 1;
stop = 20;

[C,goodpixels] = decode(imageprefix,start,stop,threshold);
