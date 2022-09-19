
%%Code to apply the SOM and HAC to decompose the surface circualtion

%% First tou need to download the SOM_toolbox available on: https://github.com/ilarinieminen/SOMToolbox.

%% To decompose the surface ciruclation first you need to download the current velocities in the area and years needed. (In our case https://marine.copernicus.eu/)

%% Training phase%%%%

%%%Preparation of the input layer %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
x=[U V ow]; %% x is the input layer for the training phase. It is composed of U and V and Okubo-Weiss (OW). It is a sample of all the data satet

Shid_1b=som_data_struct(x(:,[1,2,3]));

Shid_n1=som_normalize(Shid_1b,'var'); %% Normalize the different variable of the input layer
munits=1400; %% the size of the SOM (selected after doing sensivity tests)

sMap_hid1=som_make(Shid_n1,'munits',munits,'tracking',0,'training','Long'); % Create, initialize and train Self-Organizing Map.
sMap_hid1=som_batchtrain(sMap_hid1,Shid_n1,'radius',[300 1],'trainlen',100,'tracking',0); %  Use batch algorithm to train the Self-Organizing Map.
sMap_hid1=som_batchtrain(sMap_hid1,Shid_n1,'radius',[1 0.5],'trainlen',400,'tracking',0);
sMap_hid1=som_batchtrain(sMap_hid1,Shid_n1,'radius',[0.5 0.1],'trainlen',100,'tracking',0);
%[eq, t]=som_quality(sMap_hid1,Shid_n1) %% used to evaluate the errors (in sensivity test)

sMap_Denorm=som_denormalize(sMap_hid1); %% Denormalize the variable of the SOM map
figure;
var=[{'U'},{'V'},{'OW'}];
for i=1:size(sMap_hid1,2) %the number of variables 
    subplot(1,size(sMap_hid1,2),i)
    som_cplane(sMap_Denorm,sMap_Denorm.codebook(:,i)); shading flat %to plot 
    %the variable on the topological map
    colorbar
    title(var{i})
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OW is computed by the following equation
ow = sn.^2 + ss.^2 - w.^2;
sn = Ux - Vy ; %% Ux,Vx, Uy, and Vy are the partial derivatives 
ss = Vx + Uy ;
w  = Vx - Uy ;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Application of HAC %%%%%%%%%%%%

Z=som_cllinkage(sMap_hid1.codebook,'ward','topol','neighbors'); %% Make a hierarchical linkage of the SOM map units (sMap_hid1 could be obtained by loading the file "SOM_output.mat" in the same file).
classe_size=5; % number of classes defined 
c=cluster(Z.tree, 'maxclust',classe_size); %%  onstruct clusters from a hierarchical cluster tree
figure; som_cplane(sMap_hid1,c)%plot the clusters on the topological map
colorbar; colormap(jet(classe_size))
