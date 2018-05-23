  
target_pathfiles = uigetdir;% must be ONLY dicom files in this folder and not anymore (files with non-dicom formats)
cd(target_pathfiles);
dicom_file_list = dir(target_pathfiles);
count_of_files=length(dicom_file_list);


target_folder_name = uigetdir;% Result folder, must not equal to the "target_pathfiles"

dicom_file_path_PSF_Sharpen=strcat(target_folder_name,'\PSF_Sharpen');
dicom_file_path_PSF_Prewitt=strcat(target_folder_name,'\PSF_Prewitt');
dicom_file_path_PSF_Sobel=strcat(target_folder_name,'\PSF_Sobel');

mkdir(dicom_file_path_PSF_Sharpen);
% mkdir(dicom_file_path_PSF_Prewitt);
% mkdir(dicom_file_path_PSF_Sobel);

w = waitbar(0,'This process may take a few minutes');

for i=3:count_of_files
    
    image=dicomread(dicom_file_list(i).name); 
    dicom_info = dicominfo(dicom_file_list(i).name);
    
    image_contrast=imadjust(image);
    image_contrast_double=im2double(image_contrast);
    
    %----------------------------------------------------------------------    
 
    %PSF Sharp
    PSF_Sharp = fspecial('unsharp',0);
    noise_var = 0.0001;
    estimated_nsr = noise_var / var(image_contrast_double(:));
    
    image_filtered = imfilter(image_contrast_double,PSF_Sharp,'replicate'); 
    
 
    mkdir(strcat(dicom_file_path_PSF_Sharpen,'\',num2str(0)));
    kk3=double(double(max(max(image)))/double(max(max(im2uint16(image_filtered)))));
   
    dicomwrite(double(image_filtered*kk3), strcat(dicom_file_path_PSF_Sharpen,'\',num2str(0),'\',dicom_file_list(i).name),dicom_info,'CreateMode','Copy');
 
    

%     %----------------------------------------------------------------------
        
    waitbar((i-3)/(count_of_files-3));
end
delete(w);



