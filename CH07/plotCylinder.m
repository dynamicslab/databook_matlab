function fhandle = plotCylinder(VORT)

fhandle = figure

vortmin = -5;
vortmax = 5;
V2 = VORT;
% normalize values... not symmetric
minval = min(V2(:));
maxval = max(V2(:));
if(abs(minval)<5 && abs(maxval)<5)
    if(abs(minval)>abs(maxval))
        vortmax = maxval;
        vortmin = -maxval;
    else
        vortmin = minval;
        vortmax = -minval;
    end
end
V2(V2>vortmax) = vortmax;
V2(V2<vortmin) = vortmin;
imagesc(V2)
colormap(jet);
set(gca,'XTick',[1 50 100 150 200 250 300 350 400 449],'XTickLabel',{'-1','0','1','2','3','4','5','6','7','8'})
set(gca,'YTick',[1 50 100 150 199],'YTickLabel',{'2','1','0','-1','-2'});
set(gcf,'Position',[100 100 600 260])
axis equal
hold on

cvals = [-4 -2 -1 -.5 -.25 -.155];

[c1,h1] = contour(V2,cvals*vortmax/5,'--k','LineWidth',1.);
contour(V2,-cvals*vortmax/5,'-k','LineWidth',1.)

% Take all the info from the contourline output argument:
i0 = 1;
i2 = 1;
while i0 <  length(c1)
    i1 = i0+[1:c1(2,i0)];
    zLevel(i2) = c1(1,i0);
    hold on
    % And plot it with dashed lines:
    ph(i2) = plot(c1(1,i1),c1(2,i1),'k--','linewidth',1.);
    i0 = i1(end)+1;
    i2 = i2+1;
end
% Scrap the contourlines:
delete(h1)

t = (1:100)/100'*2*pi;
x = 49+25*sin(t);
y = 99+25*cos(t);
fill(x,y,[.3 .3 .3])
plot(x,y,'k','LineWidth',1.2)

set(gcf,'PaperPositionMode','auto')
set(gcf, 'Renderer', 'painters')