% Dichoptic Pointing data analysis MATLAB file
% This file calculates the following:
% Mean x and y error with standard deviation in pixels
% Mean x and y ocular deviation in pixels
% Mean x and y error with ocular deviation corrected (i.e. removed) in pixels (std dev should be the same - checked, yes it is)
% Local distortion index for each point in the mean array relative to where the points are actually presented (root of the sum of the squares of
% the difference, which represents mean vector length/magnitude)
% Global distortion index (mean of local distortion indices)
% Perceptual magnification index (mean relative sizes of the squares formed by the inner 4 and outer 12 test points, perceived
% vs actual locations, by shape area) (done without correcting for deviation as deviation shouldn't affect the ratios)

% 26th November 2012: This has been modified to put the yErrors into graph
% space rather than screen space. In screen space, 0,0 x,y, corresponds
% with top left corner of the screen, which means positive yError =
% perceived lower and negative yError = perceived higher, as yError is calculated by perceivedY - actualY. If this were
% plotted on a graph then everything would be flipped vertically as 0 on a graph is lower. So all
% the signs in yError have been reversed to account for this, so everything
% is plotted and calculated properly. Previous formulae weren't incorrect,
% but needed to bear in mind everything was in screen space. This way makes
% it easier to visualise. This is done right at the beginning even before
% correction for heterophoria/strabismus, to keep it consistent all the way
% through.
d = ls('*DichopticPointing.mat');
dc = cellstr(d);
tdir = cd;
for kk = 1:length(d(:,1))
    [m,n] = size(char(dc(kk)));
    data = strcat(tdir, '/',d(kk,:));
    subj = load(data)    
    screencentrex = 960.5;
    screencentrey = 540.5;
    meanxError = mean(subj.xError,3);
    yError = -(yError); % reverse signs to convert into graph space. Added 26th November 2012.
    meanyError = mean(yError,3);
    stdxError = std(xError,0,3);
    stdyError = std(yError,0,3);
    meandevnx = mean(xError(:));
    stddevnx = std(xError(:));
    meandevny = mean(yError(:));
    stddevny = std(yError(:));
    meanxErrorstrabcorr = meanxError-meandevnx; % gives matrix for deviation-corrected X error, glass pattern file should have same numbers
    meanyErrorstrabcorr = meanyError-meandevny; % gives matrix for deviation-corrected Y error, glass pattern file should have same numbers

    perceivedX1 = (targXCentre+xError(:,:,1))-meandevnx; % Get perceived pixel location of X for each point in the array, x5 arrays, corrected
    perceivedX2 = (targXCentre+xError(:,:,2))-meandevnx; % for mean x devn
    perceivedX3 = (targXCentre+xError(:,:,3))-meandevnx;
    % perceivedX4 = (targXCentre+xError(:,:,4))-meandevnx;
    % perceivedX5 = (targXCentre+xError(:,:,5))-meandevnx;
    perceivedY1 = (targYCentre+yError(:,:,1))-meandevny; % Get perceived pixel location of Y for each point in the array, x5 arrays, corrected
    perceivedY2 = (targYCentre+yError(:,:,2))-meandevny; % for mean y devn
    perceivedY3 = (targYCentre+yError(:,:,3))-meandevny;
    % perceivedY4 = (targYCentre+yError(:,:,4))-meandevny;
    % perceivedY5 = (targYCentre+yError(:,:,5))-meandevny;

    perceivedXall(:,:,1) = perceivedX1; % Create 4 x 4 x 5 array for perceivedX for purposes of getting the overall global dist and local dist, corrected
    perceivedXall(:,:,2) = perceivedX2; % for mean x devn
    perceivedXall(:,:,3) = perceivedX3;
    % perceivedXall(:,:,4) = perceivedX4;
    % perceivedXall(:,:,5) = perceivedX5;
    perceivedYall(:,:,1) = perceivedY1; % Create 4 x 4 x 5 array for perceivedY for purposes of getting the overall global dist and local dist, corrected
    perceivedYall(:,:,2) = perceivedY2; % for mean y devn
    perceivedYall(:,:,3) = perceivedY3;
    % perceivedYall(:,:,4) = perceivedY4;
    % perceivedYall(:,:,5) = perceivedY5;

    localdist1 = (((perceivedX1-targXCentre).^2)+((perceivedY1-targYCentre).^2)).^0.5;; % Calculate localdist for X and Y arrays 1-5
    localdist2 = (((perceivedX2-targXCentre).^2)+((perceivedY2-targYCentre).^2)).^0.5;;
    localdist3 = (((perceivedX3-targXCentre).^2)+((perceivedY3-targYCentre).^2)).^0.5;;
    % localdist4 = (((perceivedX4-targXCentre).^2)+((perceivedY4-targYCentre).^2)).^0.5;;
    % localdist5 = (((perceivedX5-targXCentre).^2)+((perceivedY5-targYCentre).^2)).^0.5;;

    localdistall(:,:,1) = localdist1; % create 4 x 4 x 5 array of localdist
    localdistall(:,:,2) = localdist2;
    localdistall(:,:,3) = localdist3;
    % localdistall(:,:,4) = localdist4;
    % localdistall(:,:,5) = localdist5;

    globaldistmean1 = mean(localdist1(:)); % calculate global dist. mean and stdev using local dist 1-5
    globaldiststd1 = std(localdist1(:),0);
    globaldistmean2 = mean(localdist2(:));
    globaldiststd2 = std(localdist2(:),0);
    globaldistmean3 = mean(localdist3(:));
    globaldiststd3 = std(localdist3(:),0);
    % globaldistmean4 = mean(localdist4(:));
    % globaldiststd4 = std(localdist4(:),0);
    % globaldistmean5 = mean(localdist5(:));
    % globaldiststd5 = std(localdist5(:),0);

    globaldistmeanall = mean(localdistall(:)); % calculate global dist. mean and stdev using 4 x 4 x 5 array of localdist
    globaldiststdall = std(localdistall(:),0);

    perceivedX1relscreencentre = perceivedX1-screencentrex; % calculates perceived X1-5 relative to screen centre
    perceivedX2relscreencentre = perceivedX2-screencentrex;
    perceivedX3relscreencentre = perceivedX3-screencentrex;
    % perceivedX4relscreencentre = perceivedX4-screencentrex;
    % perceivedX5relscreencentre = perceivedX5-screencentrex;

    perceivedY1relscreencentre = perceivedY1-screencentrey; % calculates perceived Y1-5 relative to screen centre
    perceivedY2relscreencentre = perceivedY2-screencentrey;
    perceivedY3relscreencentre = perceivedY3-screencentrey;
    % perceivedY4relscreencentre = perceivedY4-screencentrey;
    % perceivedY5relscreencentre = perceivedY5-screencentrey;

    targXCentrerelscreencentre = targXCentre-screencentrex; % calculates actual X relative to screen centre
    targYCentrerelscreencentre = targYCentre-screencentrey; % calculates actual Y relative to screen centre

    physdistance = (((targXCentrerelscreencentre).^2)+((targYCentrerelscreencentre).^2)).^0.5; % calculates radial vector length of actual dot from screen centre
    percdistance1 = (((perceivedX1relscreencentre).^2)+((perceivedY1relscreencentre).^2)).^0.5; % calculates radial vector length of perceived dot from screen centre
    percdistance2 = (((perceivedX2relscreencentre).^2)+((perceivedY2relscreencentre).^2)).^0.5;
    percdistance3 = (((perceivedX3relscreencentre).^2)+((perceivedY3relscreencentre).^2)).^0.5;
    % percdistance4 = (((perceivedX4relscreencentre).^2)+((perceivedY4relscreencentre).^2)).^0.5;
    % percdistance5 = (((perceivedX5relscreencentre).^2)+((perceivedY5relscreencentre).^2)).^0.5;

    percdistanceall(:,:,1) = percdistance1; % creates 4 x 4 x 5 array of perc distance 1-5
    percdistanceall(:,:,2) = percdistance2;
    percdistanceall(:,:,3) = percdistance3;
    % percdistanceall(:,:,4) = percdistance4;
    % percdistanceall(:,:,5) = percdistance5;
    % 
    reldist1 = percdistance1./physdistance; % calculates ratio of expansion/contraction of perceived dots from centre compared to actual dots. >1 = expansion, <1 = contraction
    reldist2 = percdistance2./physdistance;
    reldist3 = percdistance3./physdistance;
    % reldist4 = percdistance4./physdistance;
    % reldist5 = percdistance5./physdistance;

    reldistall = mean(percdistanceall,3)./physdistance;

    perceptmagmean = mean(reldistall(:)); % averages the 4 x 4 x 5 array to a single mean perceptual magnification
    perceptmagstd = std(reldistall(:),0); % standard deviation of the 4 x 4 x 5 perceptual magnification array
    perceptmagmean1 = mean(reldist1(:));  % individual mean perceptual magnification and stdev for arrays 1-5
    perceptmagstd1 = std(reldist1(:),0); 
    perceptmagmean2 = mean(reldist2(:)); 
    perceptmagstd2 = std(reldist2(:),0); 
    perceptmagmean3 = mean(reldist3(:)); 
    perceptmagstd3 = std(reldist3(:),0); 
    % perceptmagmean4 = mean(reldist4(:)); 
    % perceptmagstd4 = std(reldist4(:),0); 
    % perceptmagmean5 = mean(reldist5(:)); 
    % perceptmagstd5 = std(reldist5(:),0);
    filename = sprintf('%sAnalysed.mat', d(kk,1:(n-4)));
    save(filename);
end