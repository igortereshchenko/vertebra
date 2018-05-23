function [mri_interpolated_images,dicom_info_interpolated] = mri_interpolation (mri_images,dicom_info,interpolation_step)

    count_of_files = size(mri_images,3);

    x = [1:size(mri_images,1)];
    y = [1:size(mri_images,2)];
    z = [1:interpolation_step:count_of_files];
    [Xq,Yq,Zq] = meshgrid(x,y,z);
    
    for i = 1:length(dicom_info)
        slice_location(i) = dicom_info(i).SliceLocation;
    end
    slice_location
    [Y,indexes_sorted] = sort(slice_location,'descend');

    for i=1:count_of_files
        mri_images_sorted(:,:,i) = mri_images(:,:,indexes_sorted(i));  
        dicom_info_sorted(i) = dicom_info(indexes_sorted(i));
    end

    mri_interpolated_images = interp3(mri_images_sorted,Xq,Yq,Zq,'cubic');

    slicelocation_interpolated = linspace(dicom_info_sorted(1).SliceLocation,dicom_info_sorted(count_of_files).SliceLocation,size(mri_interpolated_images,3));

    temp_dicom_info = dicom_info(1);
    
    for i=1:size(mri_interpolated_images,3)
        temp_dicom_info.SliceLocation = slicelocation_interpolated(i);
        temp_dicom_info.ImagePositionPatient(3) = slicelocation_interpolated(i); 
        dicom_info_interpolated(i)=temp_dicom_info;
    end