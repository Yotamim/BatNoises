function xcor_vec = norm_cor_yot(v1,v2)
L = length(v2);
v2_normed = v2/norm(v2);

normalizing_vector = zeros(length(v1)-L,1);
cumsum_vec = [0;cumsum(abs(v1).^2)];
for i = 1:length(normalizing_vector)
    normalizing_vector(i)= 1/sqrt((cumsum_vec(i+L)-cumsum_vec(i)));
end
xcor_vec = xcorr(v1,v2_normed);
xcor_vec = xcor_vec(length(length(v1):2*length(v1)-L-1)).*normalizing_vector;

end
