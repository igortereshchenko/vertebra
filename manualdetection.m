%### DATA ###
%# some random data
X = randn(100000,1)*1;
Y = randn(100000,1)*2;

%# HACK: remove some point to make data look like a kidney
idx = (X<-1 & -4<Y & Y<4 ); X(idx) = []; Y(idx) = [];
%# or use the brush tool
%#brush on

%### imfreehand ###
figure
line('XData',X, 'YData',Y, 'LineStyle','none', ...
    'Color','b', 'Marker','.', 'MarkerSize',1);
daspect([1 1 1])
hROI = imfreehand('Closed',true);
pos = getPosition(hROI);        %# pos = wait(hROI);
delete(hROI)

%# total area
ar1 = polyarea(pos(:,1), pos(:,2));

%# plot
hold on, plot(pos(:,1), pos(:,2), 'Color','m', 'LineWidth',2)
title('Freehand')
% %---------------------------------------------------
% %### 2D histogram ###
% %# center of bins
% numBins = [20 30];
% xbins = linspace(min(X), max(X), numBins(1));
% ybins = linspace(min(Y), max(Y), numBins(2));
% 
% %# map X/Y values to bin-indices
% Xi = round( interp1(xbins, 1:numBins(1), X, 'linear', 'extrap') );
% Yi = round( interp1(ybins, 1:numBins(2), Y, 'linear', 'extrap') );
% 
% %# limit indices to the range [1,numBins]
% Xi = max( min(Xi,numBins(1)), 1);
% Yi = max( min(Yi,numBins(2)), 1);
% 
% %# count number of elements in each bin
% H = accumarray([Yi(:), Xi(:)], 1, [numBins(2) numBins(1)]);
% 
% %# total area
% THRESH = 0;
% sqNum = sum(H(:)>THRESH);
% sqArea = (xbins(2)-xbins(1)) * (ybins(2)-ybins(1));
% ar2 = sqNum*sqArea;
% 
% %# plot 2D histogram/thresholded_histogram
% figure, imagesc(xbins, ybins, H)
% axis on, axis image, colormap hot; colorbar; %#caxis([0 500])
% title( sprintf('2D Histogram, bins=[%d %d]',numBins) )
% figure, imagesc(xbins, ybins, H>THRESH)
% axis on, axis image, colormap gray
% title( sprintf('H > %d',THRESH) )
% % 
% % %### convex hull ###
% dt = DelaunayTri(X,Y);
% k = convexHull(dt);
% 
% %# total area
% ar3 = polyarea(dt.X(k,1), dt.X(k,2));
% 
% %# plot
% figure, plot(X, Y, 'b.', 'MarkerSize',1), daspect([1 1 1])
% hold on, fill(dt.X(k,1),dt.X(k,2), 'r', 'facealpha',0.2); hold off
% title('Convex Hull')
% 
% %### plot ###
% figure, hold on
% 
% %# plot histogram
% imagesc(xbins, ybins, H>=1)
% axis on, axis image, colormap gray
% 
% %# plot grid lines
% xoff = diff(xbins(1:2))/2; yoff = diff(ybins(1:2))/2;
% xv1 = repmat(xbins+xoff,[2 1]); xv1(end+1,:) = NaN;
% yv1 = repmat([ybins(1)-yoff;ybins(end)+yoff;NaN],[1 size(xv1,2)]);
% yv2 = repmat(ybins+yoff,[2 1]); yv2(end+1,:) = NaN;
% xv2 = repmat([xbins(1)-xoff;xbins(end)+xoff;NaN],[1 size(yv2,2)]);
% xgrid = [xv1(:);NaN;xv2(:)]; ygrid = [yv1(:);NaN;yv2(:)];
% line(xgrid, ygrid, 'Color',[0.8 0.8 0.8], 'HandleVisibility','off')
% 
% %# plot points
% h(1) = line('XData',X, 'YData',Y, 'LineStyle','none', ...
%     'Color','b', 'Marker','.', 'MarkerSize',1);
% 
% %# plot convex hull
% h(2) = patch('XData',dt.X(k,1), 'YData',dt.X(k,2), ...
%     'LineWidth',2, 'LineStyle','-', ...
%     'EdgeColor','r', 'FaceColor','r', 'FaceAlpha',0.5);
% 
%# plot freehand polygon
h(1) = plot(pos(:,1), pos(:,2), 'g-', 'LineWidth',2);

%# compare results
title(sprintf('area_{freehand} = %g, area_{grid} = %g, area_{convex} = %g', ...
    ar1,ar1,ar1))
legend(h, {'Points' 'Convex Jull','FreeHand'})
hold off