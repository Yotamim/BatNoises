function ClickOnACall(img_obj, evnt)
table = get(img_obj, "UserData");
t_clicked = evnt.IntersectionPoint(1);
start_times = table.times(:,1);
[~,closest_time] = min(abs(start_times-t_clicked));
if start_times(closest_time)<=t_clicked
    closest_time_row = table(closest_time,:);
else
    try
        closest_time_row = table(closest_time+1,:);
    catch
        disp("weird error")
end
% PlotPipelineCheckerPlots()




end