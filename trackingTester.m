%% data_params struct:
% - data_dir: folder containing the frames
% - out_dir: write the annotated frames to this dir
% - frame_ids
% - genFname: lambda function that generates the frame file names
%% tracking_params struct:
% - rect: target of interest in the initial frame
% - half_win: search half window radius
% - bin_n: number of bins to be used for the color histogram
%
function trackingTester(data_params, tracking_params)

getImg = @(i) imread([data_params.data_dir '/' data_params.genFname(i)]);
saveImg = @(img, i, rect) ...
    imwrite(drawBox(img, rect, [255 0 0], 3), [data_params.out_dir '/' data_params.genFname(i)]);

rect = tracking_params.rect;

% Compute the histogram on the first image
img_init = getImg(1);

% Get the sub-image that contains the target
obj = img_init(rect(2):rect(2)+rect(4), rect(1):rect(1)+rect(3), :);
% Obtain the color map that will be used to generate histogram
bin_n = tracking_params.bin_n;
[obj map] = rgb2ind(obj, bin_n);
bins = 1:bin_n;

% compute the histogram of the object. Keep as the main reference
obj = histc(obj(:), bins);

% get the image bounds
WX = size(img_init, 2);
WY = size(img_init, 1);
Wr = tracking_params.half_win;

% paint the reference frame
saveImg(img_init, 1, rect);

w = rect(3);
h = rect(4);
for i = data_params.frame_ids(2:end)
    img = getImg(i);
    img_map = rgb2ind(img, map);

    % from previous image, initial point
    x = rect(1);
    y = rect(2); 
    mc = -Inf;
    mxy = [x y];
    for i = -Wr:Wr
        for j = -Wr:Wr
            x_ = x + i;
            y_ = y + j;
            if x_ + w > WX || y_ + h > WY ...
               || x_ < 1 || y_ < 1
                continue, end
            obj_ = img_map(y_:y_+h, x_:x_+w);
            obj_ = histc(obj_(:), bins);
            c = corr2(obj, obj_);
            if c > mc
                mc = c;
                mxy = [x_, y_];
            end
        end
    end
    rect = [mxy(1) mxy(2) w h];
    imshow(drawBox(img, rect, [255 0 0], 3));
end
