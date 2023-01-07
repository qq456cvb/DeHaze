clf;
clear;
img = imread('haze.jpg');
img = imresize(img, 0.2);
[x, y, ~] = size(img);
img = imresize(img, [x / 2, y / 2]);
figure();
imshow(img);
[x, y, ~] = size(img);


radius = 7;
figure();
dark = DarkChannel(img, radius);
imshow(dark);

top_ratio = 0.001;
[~, sorted_index] = sort(dark(:), 'descend');

reshape_img = reshape(img, x*y, 3);
top = reshape_img(sorted_index(1:floor(top_ratio*x*y)), :);
A = max(top, [], 1);
A = repmat(A.', 1, x, y);
A = permute(A,[2 3 1]);

A = double(A);
img = double(img);
w = 0.95;
t = 1 - w * DarkChannel(img ./ A, radius);

figure();
imshow(t);

wk = 3;
lambda = 1e-4;
L = MattingLaplacian(img, wk);
[V, D] = eigs(L, 2, 'sm');

figure();
imshow(reshape(V(:, 2), x, y) / max(V(:, 2)));

t = (L + lambda * speye(x * y)) \ (lambda * t(:));
t = reshape(t, x, y);

figure();
imshow(t);

t0 = 0.1;
J = (img - A) ./ repmat(max(t0, t), 1, 1, 3) + A;

figure();
imshow(J/255);
