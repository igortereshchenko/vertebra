%function mri_series_minig
clear all;

dir_source_pathfiles = uigetdir;% must be ONLY dicom files in this folder and not anymore (files with non-dicom formats)

dir_list = dir(dir_source_pathfiles);



result_pathfiles = uigetdir;% Result folder, must not equal to the "target_pathfiles"


for j=1:length(dir_list)-2



source_pathfiles = strcat(dir_source_pathfiles,'\',dir_list(j+2).name);% must be ONLY dicom files in this folder and not anymore (files with non-dicom formats)





[~, data_folder_name, ~]=fileparts(source_pathfiles);





threshold_result_pathfiles = strcat(result_pathfiles,'\thresholded\',data_folder_name,'_threshold');
threshold_interpolated_result_pathfiles = strcat(result_pathfiles,'\interpolated\',data_folder_name,'_interpolated');
threshold_interpolated_threshold_surface_pathfiles = strcat(result_pathfiles,'\surfaces\',data_folder_name,'_surface');

mkdir(threshold_result_pathfiles);
mkdir(threshold_interpolated_result_pathfiles);
mkdir(threshold_interpolated_threshold_surface_pathfiles);


dicom_file_list = dir(source_pathfiles);
count_of_files=length(dicom_file_list)-2; % skip . and .. folder



system_wairbar = waitbar(0,strcat('Reading dicom thresholded files...',data_folder_name));

for i=1:count_of_files 
    dicom_images(:,:,i) = dicomread(strcat(source_pathfiles,'\',dicom_file_list(i+2).name)); % skip . and .. folder
    dicom_info(i) = dicominfo(strcat(source_pathfiles,'\',dicom_file_list(i+2).name));
    
    waitbar(i/count_of_files);
end
delete(system_wairbar);

% ------------------------THRESHOLD FILTERING --------------------------

image_threshold_filtered = threshold_deconvolution(dicom_images,1,5,0.1,0.5);


count_of_files = size(image_threshold_filtered,3) ;


system_wairbar = waitbar(0,strcat('Writing dicom thresholded files...',data_folder_name));

for i=1:count_of_files
    dicomwrite(uint16(image_threshold_filtered(:,:,i)), strcat(threshold_result_pathfiles,'\',num2str(i,'%05u')),dicom_info(i)); 
    waitbar(i/count_of_files);
end
delete(system_wairbar);




%------------------------MRI INTERPOLATION-----------------------------
%
interpolation_step(1:count_of_files-1)=4;

% interpolation_step(8)=1;
% interpolation_step(12)=1;


[mri_interpolated_images,dicom_info_interpolated] = mri_interpolation_hand (image_threshold_filtered,dicom_info,interpolation_step);
count_of_files = size(mri_interpolated_images,3) ;


%mri_interpolated_images=image_pag_remover(mri_interpolated_images,10,10);

system_wairbar = waitbar(0,strcat('Writing dicom interpolated files...',data_folder_name));

for i=1:count_of_files
    dicomwrite(uint16(mri_interpolated_images(:,:,i)), strcat(threshold_interpolated_result_pathfiles,'\',num2str(i,'%05u')),dicom_info_interpolated(i)); 
    waitbar(i/count_of_files);
end
delete(system_wairbar);

% %------------------------THRESHOLD FILTERING --------------------------
% %
% 
% 
% system_wairbar = waitbar(0,'Writing dicom finterpolated files...');
% 
% for i=1:count_of_files
%     dicomwrite(uint16(mri_interpolated_images(:,:,i)), strcat(threshold_interpolated_result_pathfiles,'\',num2str(i,'%05u')),dicom_info_interpolated(i)); 
%     waitbar(i/count_of_files);
% end
% delete(system_wairbar);
% 
% %----------------------------------------------------------------------
% %
% 
% %------------------------THRESHOLD FILTERING --------------------------
% %
% image_threshold_filtered_2 = threshold_deconvolution(mri_interpolated_images,10,7,0.9,0.5);
% system_wairbar = waitbar(0,'Writing dicom finterpolated thresholded files...');
% 
% for i=1:count_of_files
%     dicomwrite(uint16(image_threshold_filtered_2(:,:,i)), strcat(threshold_interpolated_threshold_result_pathfiles,'\',num2str(i,'%05u')),dicom_info_interpolated(i)); 
%     waitbar(i/count_of_files);
% end
% delete(system_wairbar);

end