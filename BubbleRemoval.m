% Example script of Matlab implementation of bubble removal algorithm for
% using Digital Image Correlation under in situ electrochemical hydrogen
% charging conditions.

% Takes bubble contaminated videofile or image series as input and produces
% filtered images without bubbles

% (c) 2022 Aleksander Omholt Myhre


%% for video file

[f,p]=uigetfile('*.*','Choose video file containing DIC images');
dat=VideoReader(fullfile(p,f));
saveloc = uigetdir('','Choose folder to save merged images in');
frmsToMerge = input('Number of images to merge per frame');

frm = 0;
for i = 1:frmsToMerge:dat.NumFrames
    if i+frmsToMerge <= dat.NumFrames
        frames = read(dat,[i (i+frmsToMerge-1)]);
        frames = squeeze(frames);
        frame = rescale(max(frames,[],3));
        frm = frm+1;
        imwrite(frame,strcat(saveloc,'\frame_',num2str(frm,'%04d'),'.png') );
    else
        frames = read(dat,[i, dat.NumFrames]);
        frames = squeeze(frames);
        frame = rescale(max(frames,[],3));
        frm = frm+1;
        imwrite(frame,strcat(saveloc,'\frame_',num2str(frm,'%04d'),'.png') );
    end
end



%% for image series

imloc = uigetdir('','Choose folder with images to merge');
all_frames = [dir(fullfile(imloc,'*.png'));dir(fullfile(imloc,'*.tif'));dir(fullfile(imloc,'*.jpg'));dir(fullfile(imloc,'*.bmp'))];
saveloc = uigetdir('','Choose folder to save merged images in');
frmsToMerge = input('Number of images to merge per frame');

frm = 0;
for i = 1:frmsToMerge:length(all_frames)
    clear('frames');
    if i+frmsToMerge <= length(all_frames)
        for j = 1:frmsToMerge
            frames(:,:,j) = imread(strcat(all_frames(i+j-1).folder,'\',all_frames(i+j-1).name));
        end
        frames = squeeze(frames);
        frame = rescale(max(frames,[],3));
        frm = frm+1;
        imwrite(frame,strcat(saveloc,'\frame_',num2str(frm,'%04d'),'.png') );
    else
        for j = 1:(length(all_frames)-i)
            frames(:,:,j) = imread(strcat(all_frames(i+j-1).folder,'\',all_frames(i+j-1).name));
        end
        frames = squeeze(frames);
        frame = rescale(max(frames,[],3));
        frm = frm+1;
        imwrite(frame,strcat(saveloc,'\frame_',num2str(frm,'%04d'),'.png') );
    end
end


