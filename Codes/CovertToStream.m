clear;
close all;
clc;

rawImage     = imread('story_lena_lenna_1.jpg');
image        = imresize(rgb2gray(rawImage), [128 128]);
imageZeroPad = zeros(size(image, 1) + 2 + 2, size(image, 2) + 2 + 2);
imageZeroPad(3:end - 2, 3:end - 2) = image;
%% convert to 5*5 for streaming

streamData = [];

for i = 1:size(imageZeroPad, 1) - 4
    fiveRows = imageZeroPad(i:i+4, :);
    streamData = [streamData; fiveRows(:)];
end

streamdata.time               = [];
streamdata.signals.values     = fi(streamData, 0, 8, 0);
streamdata.signals.dimensions = 1;

%% Extract Guassian output
aaa = out.Guassian.signals.values(25:5:length(streamData) + 25-1);
bbb = reshape(aaa, [132, 128]) / 273;
ccc = uint8(bbb);
guassianBlured = ccc(3:end - 2, :);

figure('Name',"Original Image")
imshow(image)
figure('Name',"Guassian Blured")
imshow(guassianBlured)

%% convert to 3*3 for streaming

guassianZeroPad = uint8(zeros(size(image, 1) + 1 + 1, size(image, 2) + 1 + 1));
guassianZeroPad(2:end - 1, 2:end - 1) = guassianBlured;

guassianData = [];

for i = 1:size(guassianZeroPad, 1) - 2
    threeRows = guassianZeroPad(i:i+2, :);
    guassianData = [guassianData; threeRows(:)];
end

guassiandata.time               = [];
guassiandata.signals.values     = fi(guassianData, 0, 8, 0);
guassiandata.signals.dimensions = 1;

%% Extract Guassian output
aaa = out.Gx.signals.values(9:3:length(guassianData) + 9-1);
bbb = reshape(aaa, [130, 128]);
ccc = uint8(bbb);
gx = ccc(2:end - 1, :);

aaa = out.Gy.signals.values(9:3:length(guassianData) + 9-1);
bbb = reshape(aaa, [130, 128]);
ccc = uint8(bbb);
gy  = ccc(2:end - 1, :);

aaa  = out.Gabs.signals.values(9:3:length(guassianData) + 9-1);
bbb  = reshape(aaa, [130, 128]);
ccc  = uint8(bbb);
gabs = ccc(2:end - 1, :);

figure('Name',"Sobel X")
imshow(gx)
figure('Name',"Sobel Y")
imshow(gy)
figure('Name',"G Abs")
imshow(gabs)

