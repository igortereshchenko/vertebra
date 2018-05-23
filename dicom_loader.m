source_pathfiles = uigetdir;% must be ONLY dicom files in this folder and not anymore (files with non-dicom formats)


dicom_file_list = dir(source_pathfiles);
count_of_files=length(dicom_file_list)-2; % skip . and .. folder


for i=1:count_of_files 
    dicom_images(:,:,i) = dicomread(strcat(source_pathfiles,'\',dicom_file_list(i+2).name)); % skip . and .. folder
     dicom_info(i) = dicominfo(strcat(source_pathfiles,'\',dicom_file_list(i+2).name));
end


imshow(dicom_images(:,:,2),[]);



