load('data_raw_Geo_collecting_0907.mat')
x=cell2mat({data.lon});
y=cell2mat({data.lat});
figure;
lon = [34.808 34.809 34.81]; 
lat = [32.1122 32.112 32.1125]; 
plot(lon,lat,'.r','MarkerSize',2) 
plot_google_map('MapType','satellite')
plot(x,y,'.r','MarkerSize',3) 