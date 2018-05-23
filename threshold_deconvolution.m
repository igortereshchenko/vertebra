

function images = threshold_deconvolution (images_for_filtration,kontrast,h_size,sigma,sharp)

system_wairbar = waitbar(0,'Thershold deconvolution...');

count_of_files = size(images_for_filtration,3);

for i=1:count_of_files
  

    
    current_image=images_for_filtration(:,:,i);
    
    current_image_max_bright=max(max(double(current_image )))
    
    current_image=imadjust(images_for_filtration(:,:,i));
    level = graythresh(current_image);
    current_image_threshold = kontrast*double(im2bw(current_image,level));
    
    image_filtered = double(current_image).*current_image_threshold;
    
    %image_filtered=image_filtered+double(current_image);
    
    
    %PSF Sharp
    PSF_Sharp = fspecial('unsharp',sharp);
    image_filtered = imfilter(image_filtered,PSF_Sharp,'replicate'); 
    
    
    %PSF Gauss    
    PSF_Gauss=fspecial('gaussian',h_size,sigma);
    image_filtered=imfilter(image_filtered,PSF_Gauss);
    
    
    
    level = graythresh(image_filtered);
    current_image_threshold = kontrast*double(im2bw(image_filtered,level));
    
    image_filtered = double(image_filtered).*current_image_threshold;
    
    
    
    resized_cofficient=double(current_image_max_bright/double(max(max(double(image_filtered)))));
    images(:,:,i) = double(image_filtered*resized_cofficient);
    
  
    waitbar(i/count_of_files);
end
delete(system_wairbar);