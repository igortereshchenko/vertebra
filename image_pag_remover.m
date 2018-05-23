function mri_images_without_gap = image_pag_remover(mri_images,gap_brightness,normal_brightness)
% gap_brightness = 10;
% normal_brightness = 10;

for l=1:size(mri_images,3)
  
mri_image=   mri_images(:,:,l);

image=double(mri_image); %image n x m pixels of greyscale

[n m]=size(image);

%remove gap 0x00
for i=1:m
    for j=1:n-3
        if (image(i,j) * image(i,j+2) * image(i,j+3))> normal_brightness;
            
            brightness = abs(image(i,j)-(image(i,j+2)+image(i,j+3))/2);
            if ( (gap_brightness < brightness) && (image(i,j+1)<=gap_brightness) )
                image(i,j+1)=(image(i,j)+image(i,j+2))/2;
            end
        end
    end
end


%remove gap 00x0
for i=1:m
    for j=1:n-3
        if (image(i,j) * image(i,j+1) * image(i,j+3))> normal_brightness;
            
            brightness = abs(image(i,j+3)-(image(i,j)+image(i,j+1))/2);
            if ( (gap_brightness < brightness) && (image(i,j+2)<=gap_brightness) )
                image(i,j+2)=(image(i,j+1)+image(i,j+3))/2;
            end
        end
    end
end


%remove gap
%0
%x
%0
%0

for i=1:m-3
    for j=1:n
        if (image(i,j) * image(i+2,j) * image(i+3,j))> normal_brightness;
            
            brightness = abs(image(i,j)-(image(i+2,j)+image(i+3,j))/2);
            if ( (gap_brightness < brightness) && (image(i+1,j)<=gap_brightness) )
                image(i+1,j)=(image(i,j)+image(i+2,j))/2;
            end
        end
    end
end


%remove gap
%0
%0
%x
%0

for i=1:m-3
    for j=1:n
        if (image(i,j) * image(i+1,j) * image(i+3,j))> normal_brightness;
            
            brightness = abs(image(i+3,j)-(image(i+1,j)+image(i,j))/2);
            if ( (gap_brightness < brightness) && (image(i+2,j)<=gap_brightness) )
                image(i+2,j)=(image(i+1,j)+image(i+3,j))/2;
            end
        end
    end
end

mri_images_without_gap(:,:,l)=image;

end