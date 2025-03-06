

for i=1:30
 Area(i,1)=cal_Area(data(i,:));
end



function Area=cal_Area(fluorArray)

Position_MaxValue=find(fluorArray(:)==max(fluorArray));
l=fluorArray(Position_MaxValue(end))+fluorArray(1);
D_fluorAraay=l-fluorArray;
Area=sum(D_fluorAraay(1:Position_MaxValue));

end