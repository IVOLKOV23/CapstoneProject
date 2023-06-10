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
    subj.screencentrex = 960.5;
    subj.screencentrey = 540.5;
    subj.meanxError = mean(subj.xError,3);
    subj.yError = -(subj.yError); % reverse signs to convert into graph space. Added 26th November 2012.
    subj.meanyError = mean(subj.yError,3);
    subj.stdxError = std(subj.xError,0,3);
    subj.stdyError = std(subj.yError,0,3);
    subj.meandevnx = mean(subj.xError(:));
    subj.stddevnx = std(subj.xError(:));
    subj.meandevny = mean(subj.yError(:));
    subj.stddevny = std(subj.yError(:));
    subj.meanxErrorstrabcorr = subj.meanxError-subj.meandevnx; % gives matrix for deviation-corrected X error, glass pattern file should have same numbers
    subj.meanyErrorstrabcorr = subj.meanyError-subj.meandevny; % gives matrix for deviation-corrected Y error, glass pattern file should have same numbers

    subj.perceivedX1 = (subj.targXCentre+subj.xError(:,:,1))-subj.meandevnx; % Get perceived pixel location of X for each point in the array, x5 arrays, corrected
    subj.perceivedX2 = (subj.targXCentre+subj.xError(:,:,2))-subj.meandevnx; % for mean x devn
    subj.perceivedX3 = (subj.targXCentre+subj.xError(:,:,3))-subj.meandevnx;
    % perceivedX4 = (targXCentre+xError(:,:,4))-meandevnx;
    % perceivedX5 = (targXCentre+xError(:,:,5))-meandevnx;
    subj.perceivedY1 = (subj.targYCentre+subj.yError(:,:,1))-subj.meandevny; % Get perceived pixel location of Y for each point in the array, x5 arrays, corrected
    subj.perceivedY2 = (subj.targYCentre+subj.yError(:,:,2))-subj.meandevny; % for mean y devn
    subj.perceivedY3 = (subj.targYCentre+subj.yError(:,:,3))-subj.meandevny;
    % perceivedY4 = (targYCentre+yError(:,:,4))-meandevny;
    % perceivedY5 = (targYCentre+yError(:,:,5))-meandevny;

    subj.perceivedXall(:,:,1) = subj.perceivedX1; % Create 4 x 4 x 5 array for perceivedX for purposes of getting the overall global dist and local dist, corrected
    subj.perceivedXall(:,:,2) = subj.perceivedX2; % for mean x devn
    subj.perceivedXall(:,:,3) = subj.perceivedX3;
    % perceivedXall(:,:,4) = perceivedX4;
    % perceivedXall(:,:,5) = perceivedX5;
    subj.perceivedYall(:,:,1) = subj.perceivedY1; % Create 4 x 4 x 5 array for perceivedY for purposes of getting the overall global dist and local dist, corrected
    subj.perceivedYall(:,:,2) = subj.perceivedY2; % for mean y devn
    subj.perceivedYall(:,:,3) = subj.perceivedY3;
    % perceivedYall(:,:,4) = perceivedY4;
    % perceivedYall(:,:,5) = perceivedY5;

    subj.localdist1 = (((subj.perceivedX1-subj.targXCentre).^2)+((subj.perceivedY1-subj.targYCentre).^2)).^0.5;; % Calculate localdist for X and Y arrays 1-5
    subj.localdist2 = (((subj.perceivedX2-subj.targXCentre).^2)+((subj.perceivedY2-subj.targYCentre).^2)).^0.5;;
    subj.localdist3 = (((subj.perceivedX3-subj.targXCentre).^2)+((subj.perceivedY3-subj.targYCentre).^2)).^0.5;;
    % localdist4 = (((perceivedX4-targXCentre).^2)+((perceivedY4-targYCentre).^2)).^0.5;;
    % localdist5 = (((perceivedX5-targXCentre).^2)+((perceivedY5-targYCentre).^2)).^0.5;;

    subj.localdistall(:,:,1) = subj.localdist1; % create 4 x 4 x 5 array of localdist
    subj.localdistall(:,:,2) = subj.localdist2;
    subj.localdistall(:,:,3) = subj.localdist3;
    % localdistall(:,:,4) = localdist4;
    % localdistall(:,:,5) = localdist5;

    subj.globaldistmean1 = mean(subj.localdist1(:)); % calculate global dist. mean and stdev using local dist 1-5
    subj.globaldiststd1 = std(subj.localdist1(:),0);
    subj.globaldistmean2 = mean(subj.localdist2(:));
    subj.globaldiststd2 = std(subj.localdist2(:),0);
    subj.globaldistmean3 = mean(subj.localdist3(:));
    subj.globaldiststd3 = std(subj.localdist3(:),0);
    % globaldistmean4 = mean(localdist4(:));
    % globaldiststd4 = std(localdist4(:),0);
    % globaldistmean5 = mean(localdist5(:));
    % globaldiststd5 = std(localdist5(:),0);

    subj.globaldistmeanall = mean(subj.localdistall(:)); % calculate global dist. mean and stdev using 4 x 4 x 5 array of localdist
    subj.globaldiststdall = std(subj.localdistall(:),0);

    subj.perceivedX1relscreencentre = subj.perceivedX1-subj.screencentrex; % calculates perceived X1-5 relative to screen centre
    subj.perceivedX2relscreencentre = subj.perceivedX2-subj.screencentrex;
    subj.perceivedX3relscreencentre = subj.perceivedX3-subj.screencentrex;
    % perceivedX4relscreencentre = perceivedX4-screencentrex;
    % perceivedX5relscreencentre = perceivedX5-screencentrex;

    subj.perceivedY1relscreencentre = subj.perceivedY1-subj.screencentrey; % calculates perceived Y1-5 relative to screen centre
    subj.perceivedY2relscreencentre = subj.perceivedY2-subj.screencentrey;
    subj.perceivedY3relscreencentre = subj.perceivedY3-subj.screencentrey;
    % perceivedY4relscreencentre = perceivedY4-screencentrey;
    % perceivedY5relscreencentre = perceivedY5-screencentrey;

    subj.targXCentrerelscreencentre = subj.targXCentre-subj.screencentrex; % calculates actual X relative to screen centre
    subj.targYCentrerelscreencentre = subj.targYCentre-subj.screencentrey; % calculates actual Y relative to screen centre

    subj.physdistance = (((subj.targXCentrerelscreencentre).^2)+((subj.targYCentrerelscreencentre).^2)).^0.5; % calculates radial vector length of actual dot from screen centre
    subj.percdistance1 = (((subj.perceivedX1relscreencentre).^2)+((subj.perceivedY1relscreencentre).^2)).^0.5; % calculates radial vector length of perceived dot from screen centre
    subj.percdistance2 = (((subj.perceivedX2relscreencentre).^2)+((subj.perceivedY2relscreencentre).^2)).^0.5;
    subj.percdistance3 = (((subj.perceivedX3relscreencentre).^2)+((subj.perceivedY3relscreencentre).^2)).^0.5;
    % percdistance4 = (((perceivedX4relscreencentre).^2)+((perceivedY4relscreencentre).^2)).^0.5;
    % percdistance5 = (((perceivedX5relscreencentre).^2)+((perceivedY5relscreencentre).^2)).^0.5;

    subj.percdistanceall(:,:,1) = subj.percdistance1; % creates 4 x 4 x 5 array of perc distance 1-5
    subj.percdistanceall(:,:,2) = subj.percdistance2;
    subj.percdistanceall(:,:,3) = subj.percdistance3;
    % percdistanceall(:,:,4) = percdistance4;
    % percdistanceall(:,:,5) = percdistance5;
    % 
    subj.reldist1 = subj.percdistance1./subj.physdistance; % calculates ratio of expansion/contraction of perceived dots from centre compared to actual dots. >1 = expansion, <1 = contraction
    subj.reldist2 = subj.percdistance2./subj.physdistance;
    subj.reldist3 = subj.percdistance3./subj.physdistance;
    % reldist4 = percdistance4./physdistance;
    % reldist5 = percdistance5./physdistance;

    subj.reldistall = mean(subj.percdistanceall,3)./subj.physdistance;

    subj.perceptmagmean = mean(subj.reldistall(:)); % averages the 4 x 4 x 5 array to a single mean perceptual magnification
    subj.perceptmagstd = std(subj.reldistall(:),0); % standard deviation of the 4 x 4 x 5 perceptual magnification array
    subj.perceptmagmean1 = mean(subj.reldist1(:));  % individual mean perceptual magnification and stdev for arrays 1-5
    subj.perceptmagstd1 = std(subj.reldist1(:),0); 
    subj.perceptmagmean2 = mean(subj.reldist2(:)); 
    subj.perceptmagstd2 = std(subj.reldist2(:),0); 
    subj.perceptmagmean3 = mean(subj.reldist3(:)); 
    subj.perceptmagstd3 = std(subj.reldist3(:),0); 
    % perceptmagmean4 = mean(reldist4(:)); 
    % perceptmagstd4 = std(reldist4(:),0); 
    % perceptmagmean5 = mean(reldist5(:)); 
    % perceptmagstd5 = std(reldist5(:),0);
    filename = sprintf('%sAnalysed.mat', d(kk,1:(n-4)));
    save(filename, '-struct', 'subj');
end