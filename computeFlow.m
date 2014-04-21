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
function ext = getExt(x, y)
    lx = min(x - 1, Tr);
    ly = min(y - 1, Tr);
    rx = min(WX - x, Tr);
    ry = min(WY - y, Tr);
    ext = [lx rx ly ry];
end

% Extract the template window given the extension
function win = getWin(img, x, y, ext)
    win = img(y-ext(3):y+ext(4), x-ext(1):x+ext(2));
end

for i = 1:numel(X) 
    for j = 1:numel(Y) 
        x = X(i);
        y = Y(j);
        % original window
        ext = getExt(x, y);
        maxCorr = 0;
        maxXY = [0 0];
        % Search the window

        if x <= Tr || y <= Tr ...
           || x + Tr >= WX || y + Tr >= WY
            WIN = [];
        else
            WIN = getWin(img1, x, y, [Tr Tr Tr Tr]);
        end

        for x_ = max(1, x-Wr) : min(WX, x+Wr)
            for y_ = max(1, y-Wr) : min(WY, y+Wr)
                if isempty(WIN) || x_ <= Tr || y_ <= Tr ...
                   || x_ + Tr >= WX || y_ + Tr >= WY
                    ext_ = min(ext, getExt(x_, y_));
                    win = getWin(img1, x, y, ext_);
                    win_ = getWin(img2, x_, y_, ext_);
                else
                    win = WIN;
                    win_ = getWin(img2, x_, y_, [Tr Tr Tr Tr]);
                end

                corr = corr2(win, win_);
                % update the maximum so far
                if corr > maxCorr
                    maxCorr = corr;
                    maxXY = [x_ y_];
                end
            end
        end

        % Store the displacement to the velocity map
        U(j, i) = maxXY(1) - x;
        V(j, i) = maxXY(2) - y;
    end
end

%% Generate the annotated image with quiver
[X Y] = meshgrid(X, Y);

fh = figure; imshow(img1), hold on, quiver(X, Y, U, V);

result = saveAnnotatedImg(fh);
end
