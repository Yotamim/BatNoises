tag_path = "C:\Users\yotam\Desktop\TagKatarinaFromat\katerina_tags\";
tag_table = LoadAllTagData(tag_path);
spec_and_fft_folder = "C:\Users\yotam\Desktop\ProjectsData\spec_and_ffts";
all_specs_and_ffts_paths = dir(spec_and_fft_folder);

all_audio_paths = tag_table.audio_path;
audio_names = cellfun(@(x) x{end},cellfun(@(x) split(x, "\"),all_audio_paths, UniformOutput=false), UniformOutput=false);
tag_table.audio_path = audio_names;
audio_keys_p1 = replace(audio_names, ".wav", "");
audio_keys_p2 = replace("__"+num2str(fix(tag_table.times(:,1)*1e4)/1e4)+"__"+num2str(fix(tag_table.times(:,2)*1e4)/1e4)+".mat", " ","");
audio_keys_p3 = replace("__"+num2str(fix(tag_table.times(:,1)*1e3)/1e3)+"__"+num2str(fix(tag_table.times(:,2)*1e3)/1e3)+".mat", " ","");

k = 1;
%%
for i = 1:length(audio_keys_p1)
    try
        a = audio_keys_p1(i)+audio_keys_p2(i);
        load(fullfile(spec_and_fft_folder,a))
    catch
        disp(k)
        k=+1;
        continue
    end
    filter_spec1 = pow2db(new_row.filter_spec{1});
    Cdata = filter_spec1;
    clims = [prctile(Cdata(:),99.9)-15, max(Cdata(:))];
    Cdata(Cdata<=clims(1)) = clims(1);
    cmap = colormap(jet);
    cdata_min_max = [min(Cdata(:)), max(Cdata(:))];
    Cdata = fix(Cdata*256/diff(cdata_min_max)-cdata_min_max(1)*256/diff(cdata_min_max)+1);
    rgb = ind2rgb(Cdata, cmap);
    rgb2 = rgb(1:4:end, :, :);
    
    figure; 
    subplot(2,2,1)
    img = image(rgb2);
    set(gca, "YDir", "normal")
    colormap jet
    title("15db")
    subplot(2,2,3)
    img = imagesc(imsegkmeans(im2single(rgb2),3));
    set(gca, "YDir", "normal")
    title("15db")
    Cdata = filter_spec1;
    clims = [prctile(Cdata(:),99.9)-20, max(Cdata(:))];
    Cdata(Cdata<=clims(1)) = clims(1);
    cmap = colormap(jet);
    cdata_min_max = [min(Cdata(:)), max(Cdata(:))];
    Cdata = fix(Cdata*256/diff(cdata_min_max)-cdata_min_max(1)*256/diff(cdata_min_max)+1);
    rgb = ind2rgb(Cdata, cmap);
    rgb2 = rgb(1:4:end, :, :);

    subplot(2,2,2)
    img = image(rgb2);
    set(gca, "YDir", "normal")
    colormap jet
    title("20db")
    subplot(2,2,4)
    img = imagesc(imsegkmeans(im2single(rgb2),3));
    set(gca, "YDir", "normal")
    title("15db")
    sgtitle(a)
    close
end



% figure; 
% img = imagesc(imsegkmeans(im2single(rgb2),3));
% 
% figure;
% clims = [prctile(filter_spec1(:),99.9)-25, max(filter_spec1(:))];
% img = imagesc(filter_spec1, clims);
% colormap jet
% set(gca, "YDir", "normal")
% 
% figure;
% clims = [prctile(filter_spec1(:),99.9)-20, max(filter_spec1(:))];
% img = imagesc(filter_spec1, clims);
% colormap jet
% set(gca, "YDir", "normal")
% 
% figure;
% imshow(rgb, []);
% set(gca,"YDir", "normal") 