clear all;
source_dicom_pathfiles = uigetdir;% must be ONLY dicom files in this folder and not anymore (files with non-dicom formats)
source_jpeg_pathfiles = uigetdir;% must be ONLY dicom files in this folder and not anymore (files with non-dicom formats)



[~, data_folder_name, ~]=fileparts(source_dicom_pathfiles);


result_pathfiles = uigetdir;% Result folder, must not equal to the "target_pathfiles"
result_pathfiles=strcat(result_pathfiles,'\',data_folder_name,'_edited_dicom');
mkdir(result_pathfiles);


dicom_file_list = dir(source_dicom_pathfiles);
count_of_files=length(dicom_file_list)-2; % skip . and .. folder




for i=1:count_of_files 
    dicom_image = dicomread(strcat(source_dicom_pathfiles,'\',dicom_file_list(i+2).name));% skip . and .. folder
    dicom_info = dicominfo(strcat(source_dicom_pathfiles,'\',dicom_file_list(i+2).name)); 
    image = rgb2gray(imread(strcat(source_jpeg_pathfiles,'\',dicom_file_list(i+2).name,'.jpeg')));
    
    image=uint16(image);
    
    image=imadjust(image);
    
    resized_cofficient=double(double(max(max(im2uint16(dicom_image))))/double(max(max(im2uint16(image)))));
    
    image = double(image)*resized_cofficient;
    
    
    dicomwrite(uint16(image), strcat(result_pathfiles,'\',dicom_file_list(i+2).name),dicom_info,'CreateMode','Copy'); 
    
end


