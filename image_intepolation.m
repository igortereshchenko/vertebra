clear all

source_pathfiles = uigetdir;% must be ONLY dicom files in this folder and not anymore (files with non-dicom formats)
%cd(target_pathfiles);
dicom_file_list = dir(source_pathfiles);
count_of_files=length(dicom_file_list);




[~, data_folder_name, ~]=fileparts(source_pathfiles);


result_pathfiles = uigetdir;% Result folder, must not equal to the "target_pathfiles"
result_pathfiles=strcat(result_pathfiles,'\',data_folder_name);
mkdir(result_pathfiles);






for i=3:count_of_files
    
    mri_image = uint16(dicomread(strcat(source_pathfiles,'\',dicom_file_list(i).name))); 
    
    mri_images(:,:,i-2)=mri_image;
    
    dicom_info(i-2) = dicominfo(strcat(source_pathfiles,'\',dicom_file_list(i).name));
    
   
end

 count_of_files = size(mri_images,3);

interpolation_step=0.25;

    x = [1:size(mri_images,1)];
    y = [1:size(mri_images,2)];
    z = [1:interpolation_step:count_of_files];
    [Xq,Yq,Zq] = meshgrid(x,y,z);


    for i = 1:count_of_files
        slice_location(i) = dicom_info(i).SliceLocation;
    end
    [Y,indexes_sorted] = sort(slice_location,'descend'); 

    for i=1:count_of_files
        mri_images_sorted(:,:,i) = mri_images(:,:,indexes_sorted(i));  
        dicom_info_sorted(i) = dicom_info(indexes_sorted(i));
    end

    mri_interpolated_images = interp3(double(mri_images_sorted),Xq,Yq,Zq,'cubic');


    slicelocation_interpolated = linspace(dicom_info_sorted(1).SliceLocation,dicom_info_sorted(count_of_files).SliceLocation,size(mri_interpolated_images,3));

    temp_dicom_info = dicom_info(1);
    
    for i=1:size(mri_interpolated_images,3)
        temp_dicom_info.SliceLocation = slicelocation_interpolated(i);
        
        temp_dicom_info.ImagePositionPatient(3) = slicelocation_interpolated(i);
        
        dicom_info_interpolated(i)=temp_dicom_info;
    
        dicomwrite(uint16(mri_interpolated_images(:,:,i)), strcat(result_pathfiles,'\',num2str(i,'%05u')),dicom_info_interpolated(i),'CreateMode','Copy'); 
    end
    
    
    