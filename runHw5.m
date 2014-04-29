function runHw5(varargin)
% runHw5 is the "main" interface that lets you execute all the 
% challenges in homework 5. It lists a set of 
% functions corresponding to the problems that need to be solved.
%
% Note that this file also serves as the specifications for the functions 
% you are asked to implement. In some cases, your submissions will be autograded. 
% Thus, it is critical that you adhere to all the specified function signatures.
%
% Before your submssion, make sure you can run runHw5('all') 
% without any error.
%
% Usage:
% runHw5                       : list all the registered functions
% runHw5('function_name')      : execute a specific test
% runHw5('all')                : execute all the registered functions

% Settings to make sure images are displayed without borders.
orig_imsetting = iptgetpref('ImshowBorder');
iptsetpref('ImshowBorder', 'tight');
temp1 = onCleanup(@()iptsetpref('ImshowBorder', orig_imsetting));

fun_handles = {@honesty,...
    @debug1a, @challenge1a,...
    @challenge2a, @challenge2b, @challenge2c};

% Call test harness
runTests(varargin, fun_handles);

%--------------------------------------------------------------------------
% Academic Honesty Policy
%--------------------------------------------------------------------------
%%
function honesty()
% Type your full name and uni (both in string) to state your agreement 
% to the Code of Academic Integrity.
signAcademicHonestyPolicy('Linxi Fan', 'lf2422');

%--------------------------------------------------------------------------
% Tests for Challenge 1: Optical flow using template matching
%--------------------------------------------------------------------------

%%
function debug1a()
img1 = imread('simple1.png');
img2 = imread('simple2.png');

search_half_window_size = 10;   % Half size of the search window
template_half_window_size = 4; % Half size of the template window
grid_MN = [32, 24];              % Number of rows and cols in the grid

result = computeFlow(img1, img2, search_half_window_size, template_half_window_size, grid_MN);
imwrite(result, 'simpleresult.png');

%%
function challenge1a()
img_list = {'flow1.png', 'flow2.png', 'flow3.png', 'flow4.png', 'flow5.png', 'flow6.png'};
for i = 1:length(img_list)
    img_stack{i} = imread(img_list{i});
end

%% 15, 20, [64, 48]
search_half_window_size = 10;   % Half size of the search window
template_half_window_size = 15; % Half size of the template window 
grid_MN = [32, 24];              % Number of rows and cols in the grid

for i = 2:length(img_stack)
    result = computeFlow(img_stack{i-1}, img_stack{i},...
        search_half_window_size, template_half_window_size, grid_MN);
    imwrite(result, ['result' num2str(i-1) '_' num2str(i) '.png']);
end
%close all;

%--------------------------------------------------------------------------
% Tests for Challenge 2: Tracking with color histogram template
%--------------------------------------------------------------------------

%%
function challenge2a
%-------------------
% Parameters
%-------------------
data_params.data_dir = 'walking_person';
data_params.out_dir = 'walking_person_result';
data_params.frame_ids = 1:250;
data_params.genFname = @(x)([sprintf('frame%d.png', x)]);

% ****** IMPORTANT ******
% In your submission, replace the call to "chooseTarget" with actual parameters
% to specify the target of interest
% tracking_params.rect = chooseTarget(data_params);
tracking_params.rect = [201 66 25 123];

% Half size of the search window
tracking_params.half_win = 4;
% Number of bins in the color histogram
tracking_params.bin_n = 16; 

% Pass the parameters to trackingTester (partial implementation below)
trackingTester(data_params, tracking_params, true);

%%
function challenge2b
%-------------------
% Parameters
%-------------------
data_params.data_dir = 'rolling_ball';
data_params.out_dir = 'rolling_ball_result';
data_params.frame_ids = 1:250;
data_params.genFname = @(x)([sprintf('frame%d.png', x)]);

% ****** IMPORTANT ******
% In your submission, replace the call to "chooseTarget" with actual parameters
% to specify the target of interest
% tracking_params.rect = chooseTarget(data_params);
tracking_params.rect = [159 134 33 39];

% Half size of the search window
tracking_params.half_win = 7;
% Number of bins in the color histogram
tracking_params.bin_n = 24; 

% Pass the parameters to trackingTester (partial implementation below)
trackingTester(data_params, tracking_params, true);

%%
function challenge2c
%-------------------
% Parameters
%-------------------
data_params.data_dir = 'basketball';
data_params.out_dir = 'basketball_result';
data_params.frame_ids = 1:250;
data_params.genFname = @(x)([sprintf('frame%d.png', x)]);

% ****** IMPORTANT ******
% In your submission, replace the call to "chooseTarget" with actual parameters
% to specify the target of interest
% tracking_params.rect = chooseTarget(data_params);
tracking_params.rect = [318 240 22 65];

% Half size of the search window
tracking_params.half_win = 6;
% Number of bins in the color histogram
tracking_params.bin_n = 16; 

% Pass the parameters to trackingTester (partial implementation below)
trackingTester(data_params, tracking_params, true);
