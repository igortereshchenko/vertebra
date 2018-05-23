%[filename, pathname] = uigetfile({'*.dcm';'*.*'},'File Selector');

%     % Load image
%     I = im2double(imread(strcat(pathname,'\',filename)));
%     figure(1); imshow(I); title('Source image');
% 
%     %PSF
%     PSF = fspecial('Motion', 2, 0);
%     noise_mean = 0;
%     noise_var = 0.0001;
%     estimated_nsr = noise_var / var(I(:));
% 
%     I = edgetaper(I, PSF);
%     figure(2); imshow(deconvwnr(I, PSF, estimated_nsr)); title('Result');
  
target_pathfiles = uigetdir;% must be ONLY dicom files in this folder and not anymore (files with non-dicom formats)
cd(target_pathfiles);
dicom_file_list = dir(target_pathfiles);
count_of_files=length(dicom_file_list);


target_folder_name = uigetdir;% Result folder, must not equal to the "target_pathfiles"

dicom_file_path_PSF_Sharpen=strcat(target_folder_name,'\PSF_Sharpen');
dicom_file_path_PSF_Prewitt=strcat(target_folder_name,'\PSF_Prewitt');
dicom_file_path_PSF_Sobel=strcat(target_folder_name,'\PSF_Sobel');

% mkdir(dicom_file_path_PSF_Sharpen);
% mkdir(dicom_file_path_PSF_Prewitt);
 mkdir(dicom_file_path_PSF_Sobel);

w = waitbar(0,'This process may take a few minutes');

for i=3:count_of_files
    
    image=dicomread(dicom_file_list(i).name); 
    dicom_info = dicominfo(dicom_file_list(i).name);
    
    image_contrast=imadjust(image);
    image_contrast_double=im2double(image_contrast);
    
    %----------------------------------------------------------------------    
    %PSF
    PSF_Sobel = fspecial('sobel');
    noise_var = 0.0001;
    estimated_nsr = noise_var / var(image_contrast_double(:));
    
    image_filtered = imfilter(image_contrast_double,PSF_Sobel,'replicate'); %deconvwnr(edgetaper(image_contrast_double, PSF_Sharp), PSF_Sharp, estimated_nsr);
    
    %figure(3); imshow(image_filtered); title('Filtered image Motion');
    %dicom_info.PixelRepresentation=1;
    %dicom_info.InstanceNumber = instn;
    %dicom_info.ImagePositionPatient='-156.914498806\-152.95652389526\-80.518714904785';
    %dicomwrite(image_filtered, strcat(pathname,'\PSF_Motion.dcm'),dicom_info, 'CreateMode', 'Create');
    kk3=double(double(max(max(image)))/double(max(max(im2uint16(image_filtered)))));
    dicomwrite(double(image_filtered*kk3), strcat(dicom_file_path_PSF_Sobel,'\PSF_Sobel_',num2str(jj),dicom_file_list(i).name),dicom_info,'CreateMode','Copy');
      
%     %----------------------------------------------------------------------    
%     
%     %PSF Prewitt
%     PSF_Prewitt = fspecial('prewitt');
%     noise_var = 0.0001;
%     estimated_nsr = noise_var / var(image_contrast_double(:));
% 
%     image_filtered = deconvwnr(edgetaper(image_contrast_double, PSF_Prewitt), PSF_Prewitt, estimated_nsr);
% 
%     kk3=double(double(max(max(image)))/double(max(max(im2uint16(image_filtered)))));
%     dicomwrite(double(image_filtered*kk3), strcat(dicom_file_path_PSF_Prewitt,'\PSF_Prewitt_',dicom_file_list(i).name),dicom_info,'CreateMode','Copy');
%     
%     %----------------------------------------------------------------------
% 
%     %PSF Sobel
%     PSF_Sobel = fspecial('sobel');
%     noise_var = 0.0001;
%     estimated_nsr = noise_var / var(image_contrast_double(:));
% 
%     image_filtered = deconvwnr(edgetaper(image_contrast_double, PSF_Sobel), PSF_Sobel, estimated_nsr);
% 
%     kk3=double(double(max(max(image)))/double(max(max(im2uint16(image_filtered)))));
%     dicomwrite(double(image_filtered*kk3), strcat(dicom_file_path_PSF_Sobel,'\PSF_Sobel_',dicom_file_list(i).name),dicom_info,'CreateMode','Copy');
%     %----------------------------------------------------------------------
        
    waitbar((i-3)/(count_of_files-3));
end
delete(w);



%c = double(dicom_info.WindowCenter);
%w = double(dicom_info.WindowWidth);
%imgScaled = 65535.*((double(image_filtered)-(c-0.5))/(w-1)+0.5);  % Rescale the data
%imgScaled = uint16(min(max(imgScaled, 0), 65535));
%figure(4); imshow(imgScaled); title('Scaled image Motion');
%dicom_info.PixelRepresentation=1;
%dicomwrite(imgScaled, strcat(pathname,'\PSF_Motion.dcm'),dicom_info, 'CreateMode', 'Copy');


