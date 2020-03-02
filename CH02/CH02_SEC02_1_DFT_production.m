clear all, close all, clc


% x = ones(500,1);
% t = .1*(1:500)';
% x = cos(t*2*pi);
% y = fft(x);
% 
% N = length(x);
% 
% plot(real(y),'k')
% hold on
% plot(real(DFT*x),'r--')

%% slow and steady
clear all, close all, clc
N = 256;
w = exp(-i*2*pi/N);
for i=1:N
    for j=1:N
        DFT(i,j) = w^((i-1)*(j-1));
    end
end

imagesc(real(DFT))
colormap jet
axis off
axis equal
box on
colorbar
set(gcf,'Position',[100 100 1000 900])
set(gcf,'PaperPositionMode','auto')
% print('-depsc2', '-loose', '../figures/DFTMatrixreal');
% print('-dpng', '-loose', '../figures/DFTMatrixreal');

%%

imagesc(imag(DFT))
colormap jet
axis off
axis equal
box on
colorbar
set(gcf,'Position',[100 100 1000 900])
set(gcf,'PaperPositionMode','auto')
% print('-depsc2', '-loose', '../figures/DFTMatriximag');
% print('-dpng', '-loose', '../figures/DFTMatriximag');
%% really fast
[I,J] = meshgrid(1:N,1:N);
DFT = w.^((I-1).*(J-1));
