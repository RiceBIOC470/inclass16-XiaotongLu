% Inclass16

%The folder in this repository contains code implementing a Tracking
%algorithm to match cells (or anything else) between successive frames. 
% It is an implemenation of the algorithm described in this paper: 
%
% Sbalzarini IF, Koumoutsakos P (2005) Feature point tracking and trajectory analysis 
% for video imaging in cell biology. J Struct Biol 151:182?195.
%
%The main function for the code is called MatchFrames.m and it takes three
%arguments: 
% 1. A cell array of data called peaks. Each entry of peaks is data for a
% different time point. Each row in this data should be a different object
% (i.e. a cell) and the columns should be x-coordinate, y-coordinate,
% object area, tracking index, fluorescence intensities (could be multiple
% columns). The tracking index can be initialized to -1 in every row. It will
% be filled in by MatchFrames so that its value gives the row where the
% data on the same cell can be found in the next frame. 
%2. a frame number (frame). The function will fill in the 4th column of the
% array in peaks{frame-1} with the row number of the corresponding cell in
% peaks{frame} as described above.
%3. A single parameter for the matching (L). In the current implementation of the algorithm, 
% the meaning of this parameter is that objects further than L pixels apart will never be matched. 

% Continue working with the nfkb movie you worked with in hw4. 

% Part 1. Use the first 2 frames of the movie. Segment them any way you
% like and fill the peaks cell array as described above so that each of the two cells 
% has 6 column matrix with x,y,area,-1,chan1 intensity, chan 2 intensity
I1='D:\nfkb_movie1.tif';
reader1=bfGetReader(I1);
ind1=reader1.getIndex(0,0,0)+1;
ind2=reader1.getIndex(0,0,1)+1;
img1=bfGetPlane(reader1,ind1);
img2=bfGetPlane(reader1,ind2);
imshow(img1,[]);

img1_sm=imfilter(img1,fspecial('gaussian',4,2));
img1_bg=imopen(img1_sm,strel('disk',100));
aimimg1=imsubtract(img1_sm,img1_bg);
imshow(aimimg1,[0 500]);
img_mask1=aimimg1>100;
img1_open=imopen(img_mask1,strel('disk',9));
imshow(img1_open);

img2_sm=imfilter(img2,fspecial('gaussian',4,2));
img2_bg=imopen(img2_sm,strel('disk',100));
aimimg2=imsubtract(img2_sm,img2_bg);
imshow(aimimg2,[0 500]);
img_mask2=aimimg2>100;
img2_open=imopen(img_mask2,strel('disk',9));
imshow(img2_open);

img1_t1_prob=regionprops(img1_open, img1, 'Centroid', 'Area', 'MeanIntensity');
img2_t2_prob=regionprops(img2_open, img2, 'Centroid', 'Area', 'MeanIntensity');

%channel 2
ind3=reader1.getIndex(0,0,0)+1;
ind4=reader1.getIndex(0,0,1)+1;
img1_c2=bfGetPlane(reader1,ind3);
img2_c2=bfGetPlane(reader1,ind4);

img1_c2_sm=imfilter(img1_c2,fspecial('gaussian',4,2));
img1_c2_bg=imopen(img1_c2_sm,strel('disk',100));
aimimg1_c2=imsubtract(img1_c2_sm,img1_c2_bg);
imshow(aimimg1_c2,[0 500]);
img_c2_mask1=aimimg1_c2>100;
img1_c2_open=imopen(img_c2_mask1,strel('disk',9));
imshow(img1_c2_open);

img2_c2_sm=imfilter(img2_c2,fspecial('gaussian',4,2));
img2_c2_bg=imopen(img2_c2_sm,strel('disk',100));
aimimg2_c2=imsubtract(img2_c2_sm,img2_c2_bg);
imshow(aimimg2_c2,[0 500]);
img2_c2_mask2=aimimg2_c2>100;
img2_c2_open=imopen(img2_c2_mask2,strel('disk',9));
imshow(img2_c2_open);

img1_t1_c2_prob=regionprops(img1_c2_open, img1_c2, 'Centroid', 'Area', 'MeanIntensity');
img2_t2_c2_prob=regionprops(img2_c2_open, img2_c2, 'Centroid', 'Area', 'MeanIntensity');

cell_1_x = cat(1,img1_t1_prob.Centroid);
cell_1_y = cat(1,img1_t1_prob.Area);
cell_1_c1mean=cat(1,img1_t1_prob.MeanIntensity);
cell_1_c2mean=cat(1,img1_t1_c2_prob.MeanIntensity);
tmp=-1*ones(size(cell_1_x));
peaks{1} = [cell_1_x, cell_1_y, tmp,cell_1_c1mean, cell_1_c2mean];

cell_2_x=cat(1,img2_t2_prob.Centroid);
cell_2_y=cat(1,img2_t2_prob.Area);
cell_2_c1mean=cat(1,img2_t2_prob.MeanIntensity);
cell_2_c2mean=cat(1,img2_t2_c2_prob.MeanIntensity);
tmp=-1*ones(size(cell_2_x));
peaks{2}=[cell_2_x,cell_2_y,tmp,cell_2_c1mean,cell_2_c2mean];

% Part 2. Run match frames on this peaks array. ensure that it has filled
% the entries in peaks as described above. 
 PeakArray=MatchFrames(peaks,2,0.1);

% Part 3. Display the image from the second frame. For each cell that was
% matched, plot its position in frame 2 with a blue square, its position in
% frame 1 with a red star, and connect these two with a green line. 
figure;
imshow(img2,[]); 
hold on;
plot(peaks{1}(:,1),peaks{1}(:,2),'r*');
hold on;
plot(peaks{2}(:,1),peaks{2}(:,2),'cs');

