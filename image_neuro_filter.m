  
target_pathfiles = uigetdir;% must be ONLY dicom files in this folder and not anymore (files with non-dicom formats)
cd(target_pathfiles);
dicom_file_list = dir(target_pathfiles);
count_of_files=length(dicom_file_list);


target_folder_name = uigetdir;% Result folder, must not equal to the "target_pathfiles"

dicom_file_path_filter_neuro=strcat(target_folder_name,'\Filter_neuro');

mkdir(dicom_file_path_filter_neuro);

w = waitbar(0,'This process may take a few minutes');

for i=3:count_of_files  
    image=dicomread(dicom_file_list(i).name); 
    dicom_info = dicominfo(dicom_file_list(i).name);
    
    image_contrast=imadjust(image);
    image_contrast_double=im2double(image_contrast);
    
  for jj=1:1:4
    %AV_Sharp = fspecial('Gaussian', 30, 0.5); % такой же результат как и
    %при fspecial('average',2);
    %AV_Sharp = fspecial('log');
    AV_Sharp=fspecial('average',jj);
%    AV_Sharp = fspecial('disk',jj);
    noise_var = 0.0001;
    estimated_nsr = noise_var / var(image_contrast_double(:));
    
    image_filtered = imfilter(image_contrast_double,AV_Sharp,'replicate');
%    image_filtered = deconvwnr(edgetaper(image_contrast_double, AV_Sharp), AV_Sharp, estimated_nsr);

    mkdir(strcat(dicom_file_path_filter_neuro,'\',num2str(jj)));
    kk3=double(double(max(max(image)))/double(max(max(im2uint16(image_filtered)))));
   
    dicomwrite(double(image_filtered*kk3), strcat(dicom_file_path_filter_neuro,'\',num2str(jj),'\',dicom_file_list(i).name),dicom_info,'CreateMode','Copy');
  end
  
%     %----------------------------------------------------------------------
        
    waitbar((i-3)/(count_of_files-3));
end
delete(w);



