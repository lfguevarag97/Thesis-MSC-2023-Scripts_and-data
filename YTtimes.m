function [ttt,lenttt] = YTtimes(yieldtabs,i)
% Todos los elementos de un Vector de tiempo (muestras)
ttt = (yieldtabs{i}(:,1)); % N-muestras N[0] - N[end] 
lenttt=length(ttt); %Cantidad de muestras length(N)
end