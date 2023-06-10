clear all;
tdir = cd;
l = ls('*L_LAnalysed.mat');
lc = cellstr(l);
r = ls('*R_RAnalysed.mat');
rc = cellstr(r);
d = ls('*DichopticPointingAnalysed.mat');
dc = cellstr(d);
for kk = 1:length(d(:,1))
    [m,n] = size(char(dc(kk)));
    data = strcat(tdir, '/',d(kk,:));
    load(data)
figure()
        plot(targXCentre,targYCentre,'ko'); hold on; axis equal off tight

        for i = 1:size(xError,3)
            plot(targXCentre-((xError(:,:,i))-meandevnx),targYCentre-((yError(:,:,i))-meandevny),'r.','MarkerSize',10); hold on
        end
        Xavg = targXCentre-meanxErrorstrabcorr; Yavg = targYCentre-meanyErrorstrabcorr;
        Xerr = std(xError,0,3); Yerr = std(yError,0,3);
        line([reshape(Xavg,[1 16]); reshape(Xavg,[1 16])],...
             [reshape(Yavg-Yerr,[1 16]); reshape(Yavg+Yerr,[1 16])],'color','k','LineWidth',1);
        line([reshape(Xavg-Xerr,[1 16]); reshape(Xavg+Xerr,[1 16])],...
             [reshape(Yavg,[1 16]); reshape(Yavg,[1 16])],'color','k','LineWidth',1); hold on
        set(gca,'xlim',[500 1300],'ylim',[100 800]);
        title(strcat(d(kk,[1:3]), d(kk,4:(n-29)), ' Dichoptic Distortion'),'FontSize',24,'FontWeight','bold');

filename = sprintf('%sDichoptic.png', d(kk,1:(n-29)));
print('-dpng', filename);
end
close all;

tdir = cd;
for kk = 1:length(l(:,1))
    data = strcat(tdir, '/',l(kk,:));
    load(data)
figure()
        plot(actualX,actualY,'ko'); hold on; axis equal off tight

        for i = 1:size(xError,3)
            plot(actualX-xError(:,:,i),actualY-yError(:,:,i),'r.','MarkerSize',10); hold on
        end
        Xavg = actualX-mean(xError,3); Yavg = actualY-mean(yError,3);
        Xerr = std(xError,0,3); Yerr = std(yError,0,3);
        line([reshape(Xavg,[1 9]); reshape(Xavg,[1 9])],...
             [reshape(Yavg-Yerr,[1 9]); reshape(Yavg+Yerr,[1 9])],'color','k','LineWidth',1);
        line([reshape(Xavg-Xerr,[1 9]); reshape(Xavg+Xerr,[1 9])],...
             [reshape(Yavg,[1 9]); reshape(Yavg,[1 9])],'color','k','LineWidth',1); hold on
        set(gca,'xlim',[500 1300],'ylim',[100 800]);
        title(strcat(l(kk,[1:3]),' Visit ', l(kk,9), ' Uniocular Distortion (Left Eye)'),'FontSize',24,'FontWeight','bold');

filename = sprintf('%sUniocL.png', char(l(kk,[1:9])));
print('-dpng', filename);
end
close all;

tdir = cd;
for kk = 1:length(r(:,1))
    data = strcat(tdir, '/',r(kk,:));
    load(data)
figure()
        plot(actualX,actualY,'ko'); hold on; axis equal off tight

        for i = 1:size(xError,3)
            plot(actualX-xError(:,:,i),actualY-yError(:,:,i),'r.','MarkerSize',10); hold on
        end
        Xavg = actualX-mean(xError,3); Yavg = actualY-mean(yError,3);
        Xerr = std(xError,0,3); Yerr = std(yError,0,3);
        line([reshape(Xavg,[1 9]); reshape(Xavg,[1 9])],...
             [reshape(Yavg-Yerr,[1 9]); reshape(Yavg+Yerr,[1 9])],'color','k','LineWidth',1);
        line([reshape(Xavg-Xerr,[1 9]); reshape(Xavg+Xerr,[1 9])],...
             [reshape(Yavg,[1 9]); reshape(Yavg,[1 9])],'color','k','LineWidth',1); hold on
        set(gca,'xlim',[500 1300],'ylim',[100 800]);
        title(strcat(l(kk,[1:3]),' Visit ', l(kk,9), ' Uniocular Distortion (Right Eye)'),'FontSize',24,'FontWeight','bold');

filename = sprintf('%sUniocR.png', char(r(kk,[1:9])));
print('-dpng', filename);
end
close all;