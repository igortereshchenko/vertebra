    function [mri_interpolated_images_final,dicom_info_interpolated] = mri_interpolation_hand(mri_images,dicom_info,interpolation_count_points)

    %interpolation_count_points 
    %промежутки (нумерация промежутков определяется по убыванию тега SliceLocation в DICOM-изображениях, то есть элемент interpolation_count_points(1) определяет кол-во точек между изображением с наибольшим (из всех скормленных на вход изображений) SliceLocation и следующим по величине за ним; ну и т.д.)
    
    count_of_files = size(mri_images,3);

     for i = 1:length(dicom_info)
         slice_location(i) = dicom_info(i).SliceLocation;
     end
    
    [~,indexes_sorted] = sort(slice_location,'descend');
    for i=1:count_of_files
        mri_images_sorted(:,:,i) = mri_images(:,:,indexes_sorted(i));  
        dicom_info_sorted(i) = dicom_info(indexes_sorted(i));
    end
    clear slice_location;
    
    x = [1:size(mri_images,1)];
    y = [1:size(mri_images,2)];
    glob_ind=1;
    for i=1:count_of_files-1
        hh=1/(interpolation_count_points(i)+1);
        hhsl=(dicom_info_sorted(i+1).SliceLocation-dicom_info_sorted(i).SliceLocation)/(interpolation_count_points(i)+1);
%         temp_dicom_info=dicom_info_sorted(i);
        for j=0:interpolation_count_points(i)
            z(glob_ind) = i + hh*j;
            slice_location(glob_ind) = dicom_info_sorted(i).SliceLocation + hhsl*j;           
%             temp_dicom_info.SliceLocation = slice_location(glob_ind);
%             temp_dicom_info.ImagePositionPatient(3) = slice_location(glob_ind); 
%             dicom_info_interpolated(glob_ind)=temp_dicom_info;       
            glob_ind = glob_ind + 1;
        end
    end
    z(glob_ind) = count_of_files;
    slice_location(glob_ind)=dicom_info_sorted(count_of_files).SliceLocation;
%     dicom_info_interpolated(glob_ind)=dicom_info_sorted(count_of_files);
    
    [Xq,Yq,Zq] = meshgrid(x,y,z);

    mri_interpolated_images_final = interp3(mri_images_sorted,Xq,Yq,Zq,'cubic');

%    [slice_location,indexes_sorted] = sort(slice_location,'descend'); 
 
%      for i=1:size(mri_interpolated_images,3)
%          mri_interpolated_images_final(:,:,i) = mri_interpolated_images(:,:,indexes_sorted(i));  
% %          dicom_info_sorted(i) = dicom_info(indexes_sorted(i));
%      end
        
    %slicelocation_interpolated = linspace(dicom_info_sorted(1).SliceLocation,dicom_info_sorted(count_of_files).SliceLocation,size(mri_interpolated_images,3));

    temp_dicom_info = dicom_info(1);
    
    for i=1:size(mri_interpolated_images_final,3)
        temp_dicom_info.SliceLocation = slice_location(i);
        temp_dicom_info.InstanceNumber=i;%10000+round(abs(slice_location(i))*100);
        temp_dicom_info.ImagePositionPatient(3) = slice_location(i); 
        dicom_info_interpolated(i)=temp_dicom_info;
    end