clear all;
source_pathfiles = uigetdir;% must be ONLY dicom files in this folder and not anymore (files with non-dicom formats)
[~, data_folder_name, ~]=fileparts(source_pathfiles)


result_pathfiles = uigetdir;% Result folder, must not equal to the "target_pathfiles"
result_pathfiles=strcat(result_pathfiles,'\',data_folder_name,'_images');
mkdir(result_pathfiles);


dicom_file_list = dir(source_pathfiles);
count_of_files=length(dicom_file_list)-2; % skip . and .. folder




for i=1:count_of_files 
    dicom_image = dicomread(strcat(source_pathfiles,'\',dicom_file_list(i+2).name)); % skip . and .. folder
    
    imwrite(imadjust(im2double(dicom_image)), strcat(result_pathfiles,'\',dicom_file_list(i+2).name,'.jpeg'),'jpeg');
end


