function [yyy,mey] = YTweights(yieldtabs,i,numcows)
yyy=cell(1,numcows);
mey={};
for j=1:numcows % [3,7,7,7,2,2]
yyy{j} = (yieldtabs{i}(:,j+4)); % 2nd col and so on 
mey{end+1}=yyy{j};
end
mey = cat(1,mey{:});
