function [ dark ] = DarkChannel( img, radius )
%DarkChannel Summary of this function goes here
%   Detailed explanation goes here

[x, y, ~] = size(img);
dark = zeros(x, y, class(img));
for i = 1:x
    for j = 1:y
        patch = img(max(i-radius, 1):min(i+radius, x), ...
            max(j-radius, 1):min(j+radius, y), :);
        rgb = min(min(patch, [], 1), [], 2);
        val = min(rgb);
        dark(i, j) = val;
    end
end
end

