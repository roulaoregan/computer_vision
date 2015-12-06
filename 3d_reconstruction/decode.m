function [C,goodpixels] = decode(imageprefix,start,stop,threshold)
% function [C,goodpixels] = decode(imageprefix,start,stop,threshold)
%
%
% Input:
%
% imageprefix : a string which is the prefix common to all the images.
%
%                  for example, pass in the prefix '/home/fowlkes/left/left_'
%                  to load the image sequence   '/home/fowlkes/left/left_01.jpg'
%                                               '/home/fowlkes/left/left_02.jpg'
%                                                          etc.
%
%  start : the first image # to load
%  stop  : the last image # to load
%
%  threshold : the pixel brightness should vary more than this threshold between the positive
%             and negative images.  if the absolute difference doesn't exceed this value, the
%             pixel is marked as undecodeable.
%
% Output:
%
%  C : an array containing the decoded values (0..1023)
%
%  goodpixels : a binary image in which pixels that were decodedable across
%  all images are marked with a 1.

i = start;
sum = 0;
summaNum = 1;

while i < stop
    %need to load a pair of images,
    %load image: 1 of 2
    %ASSUMING: if image number is less then 10 that the integer was
    %preceded by a zero
    %ASSUMING: IMAGES WILL BE .jpg?
    seqNum = int2str(i);
    seqNum2 = int2str(i+1);
    if (i < 10) && ((i+1) < 10)
        X = imread(sprintf('%s', imageprefix, '0',seqNum,'.jpg'));
        X2 = imread(sprintf('%s', imageprefix, '0',seqNum2,'.jpg'));
    elseif (i < 10) && ~((i+1) < 10)
        X = imread(sprintf('%s', imageprefix, '0',seqNum,'.jpg'));
        X2 = imread(sprintf('%s', imageprefix, seqNum2,'.jpg'));
    else
        X = imread(sprintf('%s', imageprefix, seqNum,'.jpg'));
        X2 = imread(sprintf('%s', imageprefix, seqNum2,'.jpg'));
    end
    image1 = rgb2gray(X);
    image2 = rgb2gray(X2);
    %need to compair the pair of images, each pair is the inverse of each other, so
    %for each pair of images, recover the bit by checking to see that the first image
    %is greater or less than the second.
    %imagenum = int2str(summaNum);
    %image = 'B';
    B = (abs(image1 - image2) >= threshold); %get rid of noise
    %[u,v] =size(B);
    
    
    %imagesc(B);
    axis image;
    colormap gray;
    
    %Summa: 2^(N-1)*imageN
    sum = sum + (2^(summaNum-1)*B); %1*image0 + 2*image1 + 4*image2 +
   
    summaNum = summaNum + 1;
    
    i = i + 2; %increment loop counter
end
%convert to gray code
imagesc(sum)

%decimal to gray code
[m,n] = size(sum);
goodpixels = zeros(m,n);
for i=1:m
    for j=1:n
        %first convert dec2bin; then convert bin to gray
        if sum(i,j) > 0
            goodpixels(i,j) = 1;
        else
            goodpixels(i,j) = 0;
        end
    end
end
%imagesc(goodpixels);
%??????????????? HOW TO GET grey code for "C"???
C = sum;
%for k=1:m
%    for l=1:n
 %       temp_binstr = dec2bin(sum(k,l));
  %      temp_bin = str2num(sprintf('%c',temp_binstr));
   %     [u,v] = size(temp_bin);
    %    for i=1:v
     %       binary(i) = str2num(sprintf('%c', temp_bin(i)))
            %C(k) = sum(k,l);
      %  end
       % graycode = binary;
        %for w=2:v
         %   graycode(w) = xor(binary(j-1),binary(j));
      %  end
       % C(k,l) = graycode;
   % end
%end
%imagesc(C);
%temp_bin = dec2bin(sum_index)
%test = str2num(sprintf('%c', temp_bin))
%for i=1:5
%b(i) = str2num(sprintf('%c', temp_bin(i)))
%end
%g = b;
% for j=2:v
%g(j) = xor(b(j-1),b(j))
%end
