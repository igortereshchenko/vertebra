function images = sharpen_filtration (images_for_filtration)

system_wairbar = waitbar(0,'Sharpen filtration...');

count_of_files = size(images_for_filtration,3);

for i=1:count_of_files
    
    image_contrast=imadjust(images_for_filtration(:,:,i));
    image_contrast_double=im2double(image_contrast);
    
    %PSF Sharp
    PSF_Sharp = fspecial('unsharp',0);
    noise_var = 0.0001;
  
    image_filtered = imfilter(image_contrast_double,PSF_Sharp,'replicate'); 
    
 
    
    resized_cofficient=double(double(max(max(im2uint16(images_for_filtration(:,:,i)))))/double(max(max(im2uint16(image_filtered)))));
   
    images(:,:,i) = double(image_filtered*resized_cofficient);
    

   
    waitbar(i/count_of_files);
end
delete(system_wairbar);


    
   





