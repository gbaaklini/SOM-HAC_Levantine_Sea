
filename='uv_reanalysis_19930101.nc';  %% Here we present on day example (the first of January 1993)
u_day1=ncread(filename,'ugos');
v_day1=ncread(filename,'vgos');
lon=ncread(filename,'longitude');
lat=ncread(filename,'latitude');
[Lon,Lat]=meshgrid(lon,lat);
nlon=length(lon);
nlat=length(lat);
R_earth=6371229; %in meters
delta_x=zeros(nlat,nlon);
delta_y=zeros(nlat,nlon);
% 
 for ilon=1:nlon-1
     for jlat=1:nlat-1
%         
     delta_x(jlat,ilon)=R_earth*(2*pi/360)*(Lon(jlat,ilon+1)-Lon(jlat,ilon))...
         .*cos(2*pi*Lat(jlat,ilon)/360); 
     delta_y(jlat,ilon)=R_earth*(2*pi/360)*(Lat(jlat+1,ilon)-Lat(jlat,ilon)) ;
%         
 end 
 end

delta_x=permute(delta_x,[2,1]);
u_day1_uls=u_day1./delta_x; %% transform from m/s to unitless
v_day1_uls=v_day1./delta_x;
[Uy,Ux]=gradient(u_day1_uls,lat,lon);
[Vy,Vx]=gradient(v_day1_uls,lat,lon); %% compute the partial derivative needed for OW
 
OW=okubo_weiss(Ux,Uy,Vx,Vy); 
 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 
X=som_normalize(u_day1(:),v_day1(:),OW(:),sMap_hid1);   %%% Normalize all the data set (here 01/01/1993) before the decomposion 
bmus=som_bmus(sMap_hid1,X); %%% Find the best-matching units from the map for the given vectors.
 
C=nan(size(lon,1),size(lat,1));

for ix=1:length(sMap_hid1.codebook)
C(bmus==ix)=c(ix); %%% classification lal som 7asab c l cluster
end
C(isnan(bmus))=nan;
C=reshape(C,size(lon,1),size(lat,1));
CC_all(:,:,z)=C;  %% Decompose all the dataset for every pixel during the test day 
CC=reshape(CC,size(lon,1),size(lat,1));
figure; pcolor(lon,lat,CC'); shading flat;
colormap(jet(classe_size));
colorbar; % see the pixels values after decomposition



%At the end of this code we will obtaine the decomposition of the surface circulation on 01/01/1993 into five classes 
%%The same experiment could be repeated for all the days needed 


