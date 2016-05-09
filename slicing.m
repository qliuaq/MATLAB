load trex.dat;
n = 2;%number of slice
Zmax = max(trex(:,3));
Zmin = min(trex(:,3));
thickness = (Zmax - Zmin) / n;%width of slice

startPnt = Zmin;
newArray = zeros(size(trex,1),3);%array after deleting points
trex = sortrows(trex,3);
%generate a sliced point cloud
for i = 1 : n 
    count = 1;
    test = find(trex(:,3)>startPnt);
    test2 = find(trex(:,3)<startPnt+thickness);
    test = intersect(test,test2);
    tmp = zeros(size(test,1),3);
    for j = 1:size(test)
        tmp(j,:) = trex(test(j),:);
    end
    
    tmp = sortrows(tmp,1);%sort the points according to x coordinate
    %calculate the ???
    %countd = 1;
%     delete(1,1) = tmp(1,1);
%     delete(1,2) = tmp(1,2);
%     delete(1,3) = tmp(1,3);
    di = zeros(size(tmp,1),1);
    for k = 2:size(tmp) - 1
        A = (tmp(k-1,2) - tmp(k+1,2))/(tmp(k-1,1) - tmp(k+1,1));
        B = -1;
        C = (tmp(k-1,2)-tmp(k+1,2)) * (tmp(k-1,2)-tmp(k-1,1)) / (tmp(k-1,1)-tmp(k+1,1));
        di(k) = abs(A*tmp(k,1) - tmp(k,2) + C)/sqrt(A^2 + B^2 + C^2);%???
        if di<1
            %smaller then the threshold, delete it
            %countd = countd+1;
            tmp(k,:) = [0,0,0];     
        end
    end
    
    %d = mean(di);
%     for n = 1:size(delete)
%         for m = 1:size(tmp)
%             if delete(n,:) == tmp(m,:)
%                 tmp(m,:) = [0,0,0];
%             end
%         end
%     end
    tmp(find(all(tmp==0,2)),:)=[];
    
    for q = 1:size(tmp)
        newArray(q,:) = tmp(q,:);
    end
    startPnt = startPnt + thickness;
end

newArray(find(all(newArray == 0,2)),:) = [];
figure;scatter3(newArray(:,1),newArray(:,2),newArray(:,3),'.');axis equal;
csvwrite('trex_slice_before.dat',trex);
csvwrite('trex_slice_after.dat',newArray);

before = dir('trex_slice_before.dat');
after = dir('trex_slice_after.dat'); 

compression_ratio_slice_trex = after.bytes / before.bytes;