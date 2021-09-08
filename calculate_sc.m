clear all;clc
load('data_gmv_scores.mat');
data = hammer;
%% step1: Average each ROI; ROI = (L+R)/2; CAT12 give the excel of different atlas; but their data organization also different£»
ROI = data(:,[2:end]);
ROI = table2cell(ROI);ROI = cell2mat(ROI);
average_roi = (ROI(:,[1:end/2])+ROI(:,[end/2+1:end]))/2;
% ROI(:,[end-1,end])=[];
% average_roi = (ROI(:,[1:2:end])+ROI(:,[2:2:end]))/2;
%% step2: tramsform to Z; z = (roi-mean)/sd
mean_roi = mean(average_roi);
sd_roi = std(average_roi);
[nsubj,nROI]=size(average_roi);
for i = 1:nsubj
    z = (average_roi(i,:)-mean_roi)./sd_roi;
    z_roi(i,:)=z;
end
%% step3 structural covariance 
% [Intra-individual brain structural covariance (joint variation) 
%between the ith (for i = 1 to 'total number of ROI') and j-th (for j = 1 to 'total number of ROI') regions of interest in the k-th (for k = 1 to ¡®total number of participants per dataset¡¯) participant]
%= 1/exp{[(z-transformed value of i-th region of interest in k-th participant) - (z-transformed value of j-th region of interest in k-th participant)]^2}
for i = 1:nsubj
    subj_roi = z_roi(i,:);
    for j = 1: nROI
        single_roi = subj_roi(j);
        single_roi = repmat(single_roi,[1,nROI]);
        sc_isub_jroi = 1./(exp((single_roi-subj_roi).^2));
        sc_isub(j,:)=sc_isub_jroi;
    end
    sc_all(:,:,i)=sc_isub;
end
        
