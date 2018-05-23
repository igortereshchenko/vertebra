function images = motion_deconvolution (images_for_filtration)

system_wairbar = waitbar(0,'Gauss deconvolution...');

count_of_files = size(images_for_filtration,3);

for i=1:count_of_files
    
    
    
    image_contrast=imadjust(images_for_filtration(:,:,i));
    image_contrast_double=im2double(image_contrast);
    
    %----------------------------------------------------------------------    

    %PSF Motion
    PSF_Motion = fspecial('Motion', 2, 0);
    noise_var = 0.0001;
    estimated_nsr = noise_var / var(image_contrast_double(:));
    
    image_filtered = deconvwnr(edgetaper(image_contrast_double, PSF_Motion), PSF_Motion, estimated_nsr);
    
  
    resized_cofficient=double(double(max(max(im2uint16(images_for_filtration(:,:,i)))))/double(max(max(im2uint16(image_filtered)))));
    images(:,:,i) = double(image_filtered*resized_cofficient);
    
  
    waitbar(i/count_of_files);
end
delete(system_wairbar);


 