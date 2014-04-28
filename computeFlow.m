%% img1, img2, window_radius, template_radius, grid
%
function result = computeFlow(img1, img2, Wr, Tr, grid_MN)

% Only compute for the grid equally spaced over the image
WX = size(img1, 2);
WY = size(img1, 1);
GX = grid_MN(1);
GY = grid_MN(2);

% The centers of the pixels where optical flow will be computed
X = arrayfun(@(i) floor(WX/(2*GX) + WX/GX*i), 0:(GX-1));
Y = arrayfun(@(i) floor(WY/(2*GY) + WY/GY*i), 0:(GY-1));
% velocity field for quiver()
U = zeros(numel(Y), numel(X));
V = zeros(numel(Y), numel(X));

low = @(x) max(1, x - Wr);
highx = @(x) min(WX, x + Wr);
highy = @(y) min(WY, y + Wr);

% Get the extension to all directions
function ext = getExt(x, y, r)
    lx = min(x - 1, r);
    ly = min(y - 1, r);
    rx = min(WX - x, r);
    ry = min(WY - y, r);
    ext = [lx rx ly ry];
end

% Extract the template window given the extension
function win = getWin(img, x, y, ext)
    win = img(y-ext(3):y+ext(4), x-ext(1):x+ext(2));
end

vec = zeros(2, 1);
for i = 1:numel(X) 
    for j = 1:numel(Y) 
        x = X(i);
        y = Y(j);
        % original template
        tmpl_ext = getExt(x, y, Tr);
        tmpl = getWin(img1, x, y, tmpl_ext);
        % search window
        search_ext = getExt(x, y, Wr+Tr);
        search = getWin(img2, x, y, search_ext);
        corr = normxcorr2(tmpl, search);
        [cval, maxXY] = max(corr(:));
        % Discard a low correlation
        if cval < 0.5, continue, end
        [maxY maxX] = ind2sub(size(corr), maxXY);

        % Store the displacement to the velocity map
        vec(1) = -search_ext(1) + maxX-1 - tmpl_ext(2);
        vec(2) = -search_ext(3) + maxY-1 - tmpl_ext(4);
        if norm(vec) < WX/GX + WY/GY
            U(j, i) = vec(1);
            V(j, i) = vec(2);
        end
    end
end

%% Generate the annotated image with quiver
[X Y] = meshgrid(X, Y);

fh = figure; imshow(img1), hold on, quiver(X, Y, U, V, 'autoscale', 'off');

result = saveAnnotatedImg(fh);
end
