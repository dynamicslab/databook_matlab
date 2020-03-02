function X = padflip(X);

[nx,ny] = size(X);
X = flipud(X);
X = [X zeros(nx,1);
    zeros(1,ny+1)];