function [ L ] = MattingLaplacian( img, wk )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

radius = floor(wk / 2);

[x, y, ~] = size(img);
N = x * y;
L = sparse(N, N);
u = zeros(x, y, 3);
covar = zeros(x, y, 3, 3);
w_size = zeros(x, y);

for kx = 1:x
    for ky = 1:y
        patch = img(max(kx-radius, 1):min(kx+radius, x), ...
            max(ky-radius, 1):min(ky+radius, y), :);
        patch = reshape(patch, [], 3);
        [w_size(kx, ky), ~] = size(patch);
        
        u(kx, ky, :) = mean(patch, 1);
        covar(kx, ky, :, :) = cov(patch, 1);
    end
end

h = waitbar(0,'Please wait...');

eps = 1e-8;
for kx = 1:x
    for ky = 1:y
        for mi = max(kx-radius, 1):min(kx+radius, x)
            for ni = max(ky-radius, 1):min(ky+radius, y)
                i = (ni-1) * x + mi;
                I_i = img(mi, ni, :);
                I_i = I_i(:);
                for mj = max(kx-radius, 1):min(kx+radius, x)
                    for nj = max(ky-radius, 1):min(ky+radius, y)
                        I_j = img(mj, nj, :);
                        I_j = I_j(:);
                        j = (nj-1) * x + mj;
                        delta = 0;
                        if i == j
                            delta = 1;
                        end
                        uk = u(kx, ky, :);
                        uk = uk(:);
                        covk = reshape(covar(kx, ky, :, :), 3, 3);
                        inc = delta - 1/w_size(kx, ky) * (1 + ...
                            ((I_i - uk)' / (covk + eps/w_size(kx, ky) * eye(3))) ...
                            * (I_j - uk));
                        L(i, j) = L(i, j) + inc;
%                         fprintf('L value:%f\n', inc);
                    end
                end
            end
        end
    end
    waitbar(kx / x);
end
close(h);
% sum_row = sum(L, 2);
% size(sum_row);

end

