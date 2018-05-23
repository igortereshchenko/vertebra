function im_powered=power_image(imag,power_value,count_iterations)
imag_contr=imag;
%imag_contr=imadjust(imag);
imag_contr_d=im2double(imag_contr);
% figure;
% imshow(imag_contr_d,[]);
imag_contr_sq=imag_contr_d;
imag_contr_sq1=imag_contr_d;
for i=1:count_iterations
    imag_contr_sq=double(double(imag_contr_sq.^(power_value))./double(max(max(imag_contr_sq))));
    imag_contr_sq1=double(double(imag_contr_sq1./double(max(max(imag_contr_sq1)))).^(power_value));
end

    resized_cofficient=double(double(max(max(imag_contr_d)))/double(max(max(double(imag_contr_sq1)))));
    imag_contr_sq1 = double(imag_contr_sq1*resized_cofficient);
    

% imag_contr_sq=imadjust(imag_contr_sq);
% imag_contr_sq1=imadjust(imag_contr_sq1);
% figure;
% imshow(imag_contr_sq,[]);
% figure;
% imshow(imag_contr_sq1,[]);
im_powered=imag_contr_sq1;
