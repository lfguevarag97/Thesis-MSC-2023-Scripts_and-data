clc
close all
clear 
% hold off
% randn('seed',0);

% filename = "D:\LFGG\PUJ\Maestria_PUJ\Tesis maestria\DataSet SENA 2022\";
filename = "D:\LFGG\PUJ\Maestria_PUJ\Tesis maestria\DataSet SENA 2022\PesoVacaCSV\";
csvfiles = ["PesoVacaAcerada","PesoVacaAndrea","PesoVacaAraly",...
    "PesoVacaCentavito","PesoVacaDaniela",...
"PesoVacaDanna","PesoVacaDianita","PesoVacaEmperatriz",...
"PesoVacaFernanda","PesoVacaGina","PesoVacaGuapa",...
"PesoVacaJazmin","PesoVacaJuanita","PesoVacaLeticia",...
"PesoVacaLina","PesoVacaLucia","PesoVacaLunita",...
"PesoVacaMartina","PesoMorocha","PesoVacaMuchira","PesoVacaNancy",...
"PesoVacaPacha","PesoVacaRomina","PesoVacaSol",...
"PesoVacaSoraya","PesoVacaTamara","PesoVacaViviana","PesoVacaYolima"];

% ninterp=[1,2,0,1,0,0,2,0,1,1,3,0,2,2,0,1,1,1,1,0,1,0,3,1,0,2,0];
numsvpi={299,[298,162],0,274,0,0,[288,274],0,309,...
    288,[309,298,162],0,[288,309],[309,274],0,288,299,...
    309,[274,309],274,0,288,0,[299,288,309],274,0,[288,274],0};
% numsvpi={299,[298,162],0,274,0,0,[288,274],0,309,...
%     288,[309,298,162],0,[288,309],[309,274],0,288,299,...
%     309,274,0,288,0,[299,288,309],274,0,[288,274],0};
lencsv=length(csvfiles); % 27 archivos
FILENAMES = strings(size(csvfiles)); % string Vector of size(# files)
%cargamos los archivos con extension csv
for i=1:lencsv
    FILENAMES(i)=strcat(strcat(filename,csvfiles(i)),".csv");
end

% Creamos las tablas de peso
YIELDTABLES=cell(1,length(csvfiles));
for i=1:lencsv
    aux= YieldTablegenerator(FILENAMES,i);
    YIELDTABLES{i}=aux;
end
% Aqui ya tenemos n=27 tablas, cada una con las columnas ( todas las vacas)
% con sus respectivas cantidades de muestras para cada uno de los partos
% Pero es importante mencionar que no se usan todas las vacas sino las
% que tengan suficientes muestras (En parto 1 solo 3 se usaron de 9 vacas)
LENT=zeros(1,lencsv);
T=cell(1,lencsv);
for i=1:lencsv
    [aux7,aux8] = YTtimes(YIELDTABLES,i);
    LENT(i)=aux8;
    T{i}=aux7;
end
% SVNETP={{}};
ncowspi=[3,7,7,7,2,2];
ninterp=[1,2,0,1,0,0,2,0,1,1,3,0,2,2,0,1,1,1,2,1,0,1,0,3,1,0,2,0];
% ninterp=[1,2,0,1,0,0,2,0,1,1,3,0,2,2,0,1,1,1,1,0,1,0,3,1,0,2,0];
% numsvpi={299,[298,162],0,274,0,0,[288,274],0,309,...
%     288,[309,298,162],0,[288,309],[309,274],0,288,299,...
%     309,274,0,288,0,[299,288,309],274,0,[288,274],0};
numsvpi={299,[298,162],0,274,0,0,[288,274],0,309,...
    288,[309,298,162],0,[288,309],[309,274],0,288,299,...
    309,[274,309],274,0,288,0,[299,288,309],274,0,[288,274],0};

% INTERP={zeros(1,299),{zeros(1,298),zeros(1,162)},0,zeros(1,274),0,0,...
%     {zeros(1,288),zeros(1,274)},0,zeros(1,309),zeros(1,288),...
%     {zeros(1,309),zeros(1,298),zeros(1,162)},0,...
%     {zeros(1,288),zeros(1,309)},{zeros(1,309),zeros(1,274)},...
%     0,zeros(1,288),zeros(1,299),zeros(1,309),zeros(1,274),0,...
%     zeros(1,288),0,{zeros(1,299),zeros(1,288),zeros(1,309)},...
%     zeros(1,274),0,{zeros(1,288),zeros(1,274)},0};

INTERP={zeros(1,299),{zeros(1,298),zeros(1,162)},0,zeros(1,274),0,0,...
    {zeros(1,288),zeros(1,274)},0,zeros(1,309),zeros(1,288),...
    {zeros(1,309),zeros(1,298),zeros(1,162)},0,...
    {zeros(1,288),zeros(1,309)},{zeros(1,309),zeros(1,274)},...
    0,zeros(1,288),zeros(1,299),zeros(1,309),...
    {zeros(1,274),zeros(1,309)},...
    zeros(1,274),0,...
    zeros(1,288),0,{zeros(1,299),zeros(1,288),zeros(1,309)},...
    zeros(1,274),0,{zeros(1,288),zeros(1,274)},0};
INTERP2=INTERP;

for i=1:length(ninterp)
    for j=1:length(numsvpi{i})
        auxt=YIELDTABLES{i}(:,1);
        auxy=YIELDTABLES{i}(:,2);
        auxsamp=numsvpi{i}(j);
        auxspl=(SplCubLFGG(auxt,auxy,auxsamp));
        if(length(INTERP{i})==1) % INTERP{I}=0
            auxspl=0;
            INTERP{i}=auxspl;
        elseif (length(INTERP{i})>1 && length(INTERP{i})<=3)
            INTERP{i}(j)={auxspl'};
        elseif (length(INTERP{i})>3)
            INTERP{i}={auxspl'};
        end
    end
end
INTERP3=INTERP';



% MET=cell(1,lencsv);
% ncows=zeros(1,lencsv);
% % for i=1:lencsv
% %     % Size() inidica las filas y columnas de cada tabla
% %     % Solo me interesan las columnas -1 que es de las muestras de tiempo
% %     % y lo divido entre 3, pues tengo valores NETOS, AM Y PM
% %     % para una misma vaca
% %     ncows(i)= (size(YIELDTABLES{i},2)-1)/3;
% %     % Luego para Mixed Effects tengo que repetir las muestras de tiempo
% %     % dependiendo del numero de vacas que haya en ese parto
% %     MET{i}=repmat(T{i},ncows(i),1);
% % end
% % SVY es una cell que guarda
% SVY={{}};
% MESY={{}};
% for i=1:lencsv
% %     ncows(i)= (size(YIELDTABLES{i},2))
%     ncows(i)= (size(YIELDTABLES{i},2)-1)
%     [yvp,MEY] = YTyields(YIELDTABLES,i,ncows(i));
%     SVY{i}=yvp;
%     MESY{i}=MEY;
% end
% % Aqui tengo como resultado:
% %  yyy{j} --> pasa a ser SVY, que guarda una tabla de producciones NETAS
% % mientras que mey{j} pasa a ser --> MESY, que guarda esos valores
% % en un unico array 1D de
% % length(vacasNET*(n-muestras)) EJ 897=3vacas*299 muestras
% 
% 
% 
% % Sujetos de prueba para cada SuperParto
% % Dependiendo de cada SuperParto, hay un numero de vacas numcows
% % y como son pocos pues se escriben a mano
% % Parto #1 :   ["Sol","Lunita","Acerada"]
% % Parto #2 :   ["Gina","Juanita","Vivna","Dnita","Lucia","Sol","Pacha"]
% % Parto #3 :   ["Juanita","Guapa","Sol","Morocha","Fernda","Martina","Leticia"]
% % Parto #4 :   ["Viviana","Dianita","Morocha","Centavito","Leticia","Muchira","Soraya"]
% % Parto #5 :   ["Guapa","Andrea"]
% % Parto #6 :   ["Guapa","Andrea"]
SUBS={["Sol","Lunita","Acerada"], ...
    ["Gina","Juanita","Viviana","Dianita","Lucia","Sol","Pacha"], ...
    ["Juanita","Guapa","Sol","Morocha","Fernanda","Martina","Leticia"], ...
    ["Viviana","Dianita","Morocha","Centavito","Leticia","Muchira","Soraya"], ...
    ["Guapa","Andrea"], ...
    ["Guapa","Andrea"]};

csvfiles2 = ["PesoAcerada","PesoAndrea","PesoAndrea",...
    "PesoCentavito","PesoDianita","PesoDianita",...
"PesoFernanda","PesoGina","PesoGuapa","PesoGuapa","PesoGuapa",...
"PesoJuanita","PesoJuanita","PesoLeticia","PesoLeticia",...
"PesoLucia","PesoLunita","PesoMartina","PesoMorocha","PesoMorocha","PesoMuchira","PesoPacha",...
"PesoSol","PesoSol","PesoSol","PesoSoraya",...
"PesoViviana","PesoViviana"];
FILENAMESINTERP = strings(size(csvfiles)); % string Vector of size(# files)
%cargamos los archivos con extension csv
SP1INTERP={zeros(1,299),zeros(1,299),zeros(1,299)};
SP2INTERP={zeros(1,288),zeros(1,288),zeros(1,288),...
           zeros(1,288),zeros(1,288),zeros(1,288),zeros(1,288)};
SP3INTERP={zeros(1,309),zeros(1,309),zeros(1,309),...
           zeros(1,309),zeros(1,309),zeros(1,309),zeros(1,309)};
SP4INTERP={zeros(1,274),zeros(1,274),zeros(1,274),...
           zeros(1,274),zeros(1,274),zeros(1,274),zeros(1,274)};
SP5INTERP={zeros(1,298),zeros(1,298)};
SP6INTERP={zeros(1,162),zeros(1,162)};
SP1varnames={};SP2varnames={};SP3varnames={};
SP4varnames={};SP5varnames={};SP6varnames={};

m=1;
n=0;
sp1=1;
sp2=1;
sp3=1;
sp4=1;
sp5=1;
sp6=1;
FILENAMESTAB = {};
for i=1:lencsv
    if(numsvpi{i}~=0)
        for j=1:length(numsvpi{i})
            auxfun=string(numsvpi{i}(j));
            auxcsv=csvfiles2(m);
            auxtxt=(auxcsv+auxfun);
            FILENAMESTAB{m}=auxtxt;
            FILENAMESINTERP(m)=strcat(auxtxt,".csv");
            if(numsvpi{i}(j)==299)
                SP1INTERP{sp1} = INTERP{i}(j);
                SP1varnames{sp1}=auxtxt;
                sp1=sp1+1;
            end
            if(numsvpi{i}(j)==288)
                SP2INTERP{sp2} = INTERP{i}(j);
                SP2varnames{sp2}=auxtxt;
                sp2=sp2+1;
            end
            if(numsvpi{i}(j)==309)
                SP3INTERP{sp3} = INTERP{i}(j);
                SP3varnames{sp3}=auxtxt;
                sp3=sp3+1;
            end
            if(numsvpi{i}(j)==274)
                SP4INTERP{sp4} = INTERP{i}(j);
                SP4varnames{sp4}=auxtxt;
                sp4=sp4+1;
            end
            if(numsvpi{i}(j)==298)
                SP5INTERP{sp5} = INTERP{i}(j);
                SP5varnames{sp5}=auxtxt;
                sp5=sp5+1;
            end
            if(numsvpi{i}(j)==162)
                SP6INTERP{sp6} = INTERP{i}(j);
                SP6varnames{sp6}=auxtxt;
                sp6=sp6+1;
            end
            m=m+1;
        end
    end
end
FilesInterp=FILENAMESINTERP';
% 
% T1 = (cell2table(SP1INTERP));
% % T1=T1';
% writetable(T1,'PesoSVP1.csv');
% 
% T2 = cell2table(SP2INTERP);
% % T2=T2';
% writetable(T2,'PesoSVP2.csv');
% 
% T3 = cell2table(SP3INTERP);
% % T3=T3';
% writetable(T3,'PesoSVP3.csv');
% 
% T4 = cell2table(SP4INTERP);
% % T4=T4';
% writetable(T4,'PesoSVP4.csv');
% 
% T5 = cell2table(SP5INTERP);
% % T5=T5';
% writetable(T5,'PesoSVP5.csv');
% 
% T6 = cell2table(SP6INTERP);
% % T6=T6';
% writetable(T6,'PesoSVP6.csv');
% % Convert cell to a table and use first row as variable names
% T = cell2table(c(2:end,:),'VariableNames',c(1,:))
%  
% % Write the table to a CSV file
% writetable(T,'example.csv')
% Usamos una serie de colores distintos para cada plot de cada parto
% COLORS =["rgb","rgbcmyk","rgbcmyk",...
%     "rgbcmyk","cm","cm"];
% 
% % Para mixed effects necesitamos repetir T y los registros
% % pero para efectos de ploteo, tambien necesitamos que las primeras
% % N-muestras sean asociadas a la primera vaca EJ "SOL" 299 veces y lo mismo
% % con las otras vacas..... ESO PASA CON SUBi
% SUBi={{}};
% % En SUBJECTS YA TENEMOS EL VECTOR 1D con SOL, SOL SOL, ...., Lina, Lina...
% % para el total de 897 muestras
% SUBJECTS={{}};
% % for i=1:lencsv
% %     for j=1:ncows(i)
% %         SUBi{i,j}=strings([1,length(T{i})]);
% %         SUBi{i,j}(:)=SUBS{i}(j);
% %         aux20=cat(1,SUBi{i,:});
% %         aux20=aux20';
% %         aux20=reshape(aux20,1,[]);
% %     end
% %     SUBJECTS{end+i-1}=aux20;
% % end
% 
% emptyCells = cellfun(@isempty,SUBJECTS);
% %  remove empty cells por si las hay. Esto pasaba algunas veces que cogia
% % y agregaba valores en vacio [] porque la matriz (tabla) debia tener igual
% % longitud, pero para cada vaca hay distinta cantidad de muestras
% SUBJECTS(emptyCells) = [];
% %=================================================
% colors = 'rgbcmyk';

% % subs=["Sol","Lunita","Acerada"];
% subs=SUBS{1}; % subs=SUBS{1} es una linea usada para corroborar que 
% % SUBS alamacena los nombres de las numcows-vacas de cada parto
% % [3,7,7,7,2,2]
% 
% % subject=[sub1 sub2 sub3]'; % pacientes/vacas
% subject=SUBJECTS{1}'; % subject=SUBJECTS{1}' es una linea usada para 
% % corroborar que SUBJECTS alamacena el vector de pacientes de cada parto
% % repetidos para el plot de Mixed Effects.



