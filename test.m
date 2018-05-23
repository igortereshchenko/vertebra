clear all;
source_dicom_pathfiles = 'C:\Users\Igor\Desktop\111\ANOx48r565rfh11gj\PA000001\ST000001\SE000003';%uigetdir;% must be ONLY dicom files in this folder and not anymore (files with non-dicom formats)




[~, data_folder_name, ~]=fileparts(source_dicom_pathfiles);


result_pathfiles = 'C:\Users\Igor\Desktop\111\ANOx48r565rfh11gj\PA000001\ST000001\result';%uigetdir;% Result folder, must not equal to the "target_pathfiles"
result_pathfiles=strcat(result_pathfiles,'\',data_folder_name,'_edited_dicom');
mkdir(result_pathfiles);


dicom_file_list = dir(source_dicom_pathfiles);
count_of_files=length(dicom_file_list)-2; % skip . and .. folder




volume = dicom23D(source_dicom_pathfiles);

%I=double(x);

%select filter parameters
sigmaS=5;
sigmaR=15;
samS=5;
samR=15;

%get the filter result
Ibf=bilateral3(volume, sigmaS,sigmaS,sigmaR,samS,samR);



for i=1:count_of_files 
    dicom_image = dicomread(strcat(source_dicom_pathfiles,'\',dicom_file_list(i+2).name));% skip . and .. folder
    dicom_info = dicominfo(strcat(source_dicom_pathfiles,'\',dicom_file_list(i+2).name)); 
   
    i
    
    image_contrast=imadjust(dicom_image);
    image_contrast_double=im2double(image_contrast);
    
    
    
    
    
    image_filtered = Ibf(:,:,i);
    
    
    
    
    result = uint16(double(max(max(dicom_image)))* mat2gray(image_filtered,[min(min(image_filtered)) max(max(image_filtered))]));
    
       
   
    
    
    dicomwrite(result, strcat(result_pathfiles,'\',dicom_file_list(i+2).name),dicom_info,'CreateMode','Copy'); 
    
end


