clear all, close all, clc

load ../DATA/allFaces.mat

allPersons = zeros(n*6,m*6);
count = 1;
for i=1:6
    for j=1:6
        allPersons(1+(i-1)*n:i*n,1+(j-1)*m:j*m) ...
            = reshape(faces(:,1+sum(nfaces(1:count-1))),n,m);
        count = count + 1;
    end
end

figure(1), axes('position',[0  0  1  1]), axis off
imagesc(allPersons), colormap gray

%%

for person = 1:length(nfaces)
    subset = faces(:,1+sum(nfaces(1:person-1)):sum(nfaces(1:person)));
    allFaces = zeros(n*8,m*8);
    
    count = 1;
    for i=1:8
        for j=1:8
            if(count<=nfaces(person)) 
                allFaces(1+(i-1)*n:i*n,1+(j-1)*m:j*m) ...
                    = reshape(subset(:,count),n,m);
                count = count + 1;
            end
        end
    end
    
    imagesc(allFaces), colormap gray    
end