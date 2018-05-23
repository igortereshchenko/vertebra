%function mri_series_minig

source_pathfiles = uigetdir;% must be ONLY dicom files in this folder and not anymore (files with non-dicom formats)
[~, data_folder_name, ~]=fileparts(source_pathfiles)

result_pathfiles = uigetdir;% Result folder, must not equal to the "target_pathfiles"
result_pathfiles=strcat(result_pathfiles,'\',data_folder_name);
mkdir(result_pathfiles);

dicom_file_list = dir(source_pathfiles);
count_of_files=length(dicom_file_list)-2; % skip . and .. folder


image_gauss_filtered_path = strcat(result_pathfiles,'\image_gauss_filtered');
image_gauss_filtered_interpolated_path = strcat(result_pathfiles,'\image_gauss_filtered_intrpolated');
image_gauss_filtered_interpolated_sharpen_path = strcat(result_pathfiles,'\image_gauss_filtered_intrpolated_sharpen');
image_gauss_filtered_interpolated_motion_path = strcat(result_pathfiles,'\image_gauss_filtered_intrpolated_motion');

mkdir(image_gauss_filtered_path);
mkdir(image_gauss_filtered_interpolated_path);
mkdir(image_gauss_filtered_interpolated_sharpen_path);
mkdir(image_gauss_filtered_interpolated_motion_path);


for i=1:count_of_files 
    dicom_images(:,:,i) = dicomread(strcat(source_pathfiles,'\',dicom_file_list(i+2).name)); % skip . and .. folder
    dicom_info(i) = dicominfo(strcat(source_pathfiles,'\',dicom_file_list(i+2).name));
end


 %------------------------GAUSS DECONVOLUTION---------------------------
 %
image_gauss_filtered = gauss_deconvolution(dicom_images);

system_wairbar = waitbar(0,'Writing Gauss filtered dicom files...');
count_of_files = size(image_gauss_filtered,3) ;
for i=1:count_of_files
    dicomwrite(image_gauss_filtered(:,:,i), strcat(image_gauss_filtered_path,'\',num2str(i,'%05u')),dicom_info(i)); 
    waitbar(i/count_of_files);
end
delete(system_wairbar);
 %----------------------------------------------------------------------
 %
 
 %------------------------MRI INTERPOLATION-----------------------------
 %
%interpolation_step=0.5;
interpolation_count_points(1:count_of_files-1)=1; interpolation_count_points(1)=0; interpolation_count_points(2)=0;interpolation_count_points(3)=2; interpolation_count_points(4)=2;
[mri_interpolated_images,dicom_info_interpolated] = mri_interpolation_hand(image_gauss_filtered,dicom_info,interpolation_count_points);
%[mri_interpolated_images,dicom_info_interpolated] = mri_interpolation(image_gauss_filtered,dicom_info,interpolation_step);
count_of_files = size(mri_interpolated_images,3) ;

system_wairbar = waitbar(0,'Writing interpolated dicom files...');
for i=1:count_of_files 
    dicomwrite(mri_interpolated_images(:,:,i), strcat(image_gauss_filtered_interpolated_path,'\',num2str(i,'%05u')),dicom_info_interpolated(i)); 
    waitbar(i/count_of_files);
end
delete(system_wairbar);



%-------------------------IMAGE SHARPEN FILTRATION---------------------
%


image_gauss_filtered_sharpen = sharpen_filtration(mri_interpolated_images);



system_wairbar = waitbar(0,'Writing sharpen filtered dicom files...');
count_of_files = size(image_gauss_filtered_sharpen,3) ;

for i=1:count_of_files
    dicomwrite(image_gauss_filtered_sharpen(:,:,i), strcat(image_gauss_filtered_interpolated_sharpen_path,'\',num2str(i,'%05u')),dicom_info_interpolated(i)); 
    waitbar(i/count_of_files);
end
delete(system_wairbar);

%----------------------------------------------------------------------
%

%-------------------------IMAGE MOTION FILTRATION---------------------
% 
image_gauss_filtered_motion = motion_deconvolution(mri_interpolated_images); 
 
 system_wairbar = waitbar(0,'Writing motion filtered dicom files...');
count_of_files = size(image_gauss_filtered_motion,3) ;

for i=1:count_of_files
    dicomwrite(image_gauss_filtered_motion(:,:,i), strcat(image_gauss_filtered_interpolated_motion_path,'\',num2str(i,'%05u')),dicom_info_interpolated(i)); 
    waitbar(i/count_of_files);
end
delete(system_wairbar);
