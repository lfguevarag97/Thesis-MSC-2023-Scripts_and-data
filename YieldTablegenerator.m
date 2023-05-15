function [YT] = YieldTablegenerator(filenames,i)
YT = readtable(filenames(i)); % Tabla de SVNETP1 (10 COLUMNAS - para Filenames(1), varia para cada parto)
YT =  table2array(YT);
end

