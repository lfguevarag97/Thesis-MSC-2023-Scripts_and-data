function [yyy,mey] = YTyields(yieldtabs,i,numcows)
yyy=cell(1,numcows);
mey={};
% Numcows es un vector que almacena la cantidad de vacas
% usadas para cada analisis de super partos
% Numcows = [3,7,7,7,2,2]
for j=1:numcows % [3,7,7,7,2,2]
    % Debo guardar todas las columnas con sus valores NETOS unicamente
    % y no con los valores AM y PM que no voy a usar
    yyy{j} = (yieldtabs{i}(:,j+1)); % 2nd col and so on 
    % Por eso solo cojo de la 2da columna (primer vaca)
    % hasta la ultima vaca (numcows) que varia para cada parto
    
    % Con mey, acumulo las producciones de las numcows-vacas en un vector
    % de vectores así --> {299muestrasV1 299muestrasV2 299muestrasV3}
    mey{end+1}=yyy{j};
end
% Finalmente, transformo el vector de cells de 1x3 a un solo vector de 1D
mey = cat(1,mey{:}); 
% Teniendo como resultado que yyy{j} guarde una tabla de producciones NETAS
% mientras que mey{j} guarda esos valores en un unico array 1D de
% length(vacasNET*(n-muestras)) EJ 897=3vacas*299 muestras

