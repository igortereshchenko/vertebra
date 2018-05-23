  
target_pathfiles = uigetdir;% must be ONLY dicom files in this folder and not anymore (files with non-dicom formats)
cd(target_pathfiles);
dicom_file_list = dir(target_pathfiles);
count_of_files=length(dicom_file_list);

dicom_file_path_PSF_Sharpen=strcat(target_pathfiles,'\Dicom_pathed');

mkdir(dicom_file_path_PSF_Sharpen);
% mkdir(dicom_file_path_PSF_Prewitt);
% mkdir(dicom_file_path_PSF_Sobel);

w = waitbar(0,'This process may take a few minutes');

for i=3:count_of_files
    
    image=dicomread(dicom_file_list(i).name); 
    dicom_info = dicominfo(dicom_file_list(i).name);
    
    dicom_info.ImagePositionPatient(1)=-dicom_info.ImagePositionPatient(1);
    dicom_info.ImagePositionPatient(2)=-dicom_info.ImagePositionPatient(2);
   
    dicomwrite(image, strcat(dicom_file_path_PSF_Sharpen,'\',dicom_file_list(i).name),dicom_info,'CreateMode','Copy');
%     %--------------------------------------------------------------------

    waitbar((i-3)/(count_of_files-3));
end
delete(w);