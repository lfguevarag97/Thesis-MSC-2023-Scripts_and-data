clc
close all
clear
path = "D:\LFGG\PUJ\Maestria_PUJ\Tesis maestria\DataSet SENA 2022\PesVacCSV\";

% csvfiles = ["Acer","Andre","Ara","Cen","Dani","Dan",...
%     "Dian","Emp","Fer","Gina","Gpa","Jaz","Juan",...
%     "Leti","Lin","Luci","Lun","Mart","Mor","Muc",...
%     "Nancy","Pac","Rom","Sol","Sor","Tam","Viv","Yol"];
%===============================================================
% INTERP={zeros(1,299),{zeros(1,298),zeros(1,162)},0,zeros(1,274),0,0,...
%     {zeros(1,288),zeros(1,274)},0,zeros(1,309),zeros(1,288),...
%     {zeros(1,309),zeros(1,298),zeros(1,162)},0,...
%     {zeros(1,288),zeros(1,309)},{zeros(1,309),zeros(1,274)},...
%     0,zeros(1,288),zeros(1,299),zeros(1,309),...
%     {zeros(1,274),zeros(1,309)},...
%     zeros(1,274),0,...
%     zeros(1,288),0,{zeros(1,299),zeros(1,288),zeros(1,309)},...
%     zeros(1,274),0,{zeros(1,288),zeros(1,274)},0};
% ninterp=[1,2,0,1,0,0,2,0,1,1,3,0,2,2,0,1,1,1,2,1,0,1,0,3,1,0,2,0];
% numsvpi={299,[298,162],0,274,0,0,[288,274],0,309,...
%     288,[309,298,162],0,[288,309],[309,274],0,288,299,...
%     309,[274,309],274,0,288,0,[299,288,309],274,0,[288,274],0};
%===============================================================

%===============================================================
INTERP={zeros(1,299),{zeros(1,298),zeros(1,162)},0,zeros(1,274),0,0,...
    {zeros(1,288),zeros(1,274)},0,zeros(1,309),zeros(1,288),...
    {zeros(1,309),zeros(1,298)},zeros(1,162),...
    {zeros(1,288),zeros(1,309)},{zeros(1,309),zeros(1,274)},...
    0,zeros(1,288),zeros(1,299),zeros(1,309),...
    {zeros(1,274),zeros(1,309)},...
    zeros(1,274),0,...
    zeros(1,288),{zeros(1,299),zeros(1,288)},zeros(1,309),...
    zeros(1,274),0,{zeros(1,288),zeros(1,274)},0};
ninterp=[1,2,0,1,0,0,2,0,1,1,2,1,2,2,0,1,1,1,2,1,0,1,2,1,1,0,2,0];
% numsvpi={299,[298,162],0,274,0,0,[288,274],0,309,...
%     288,[309,298],162,[288,309],[309,274],0,288,299,...
%     309,[274,309],274,0,288,[299,288],309,274,0,[288,274],0};
%===============================================================

%===========================================================
csvfiles = ["Acer","Andre","Andre","Cen","Dian","Dian","Fer",...
    "Gina","Gpa","Gpa","Gpa","Juan","Juan","Leti","Leti",...
    "Luci","Lun","Mart","Mor","Mor","Muc","Pac",...
    "Sol","Sol","Sol","Sor","Viv","Viv"];
lencsv=length(csvfiles); % 28 archivos
FILENAMES = strings(size(csvfiles)); % string Vector of size(# files)
%===========================================================

%cargamos los archivos con extension csv
auxfilename="PesVac";
for i=1:lencsv
    FILENAMES(i)=strcat(auxfilename,csvfiles(i));
    FILENAMES(i)=strcat(strcat(path,FILENAMES(i)),".csv");
end
clear auxfilename;

% Creamos las tablas de peso
WEIGHTTABLES=cell(1,length(csvfiles));
for i=1:lencsv
    aux= YieldTablegenerator(FILENAMES,i);
    WEIGHTTABLES{i}=aux;
end
clear aux;
% Aqui ya tenemos n=28 tablas, cada una con las columnas ( todas las vacas)
% con sus respectivas cantidades de muestras para cada uno de los partos
% Pero es importante mencionar que no se usan todas las vacas sino las
% que tengan suficientes muestras (En parto 1 solo 3 se usaron de 9 vacas)
LENT=zeros(1,lencsv);
T=cell(1,lencsv);
for i=1:lencsv
    [aux7,aux8] = YTtimes(WEIGHTTABLES,i);
    LENT(i)=aux8;
    T{i}=aux7;
end
clear aux7 aux8;
% SVNETP={{}};
ncowspi=[3,7,7,7,2,2];

% numsvpi={299,299,[299,288,309],...
%     [288,274],288,[288,309],288,...
%     288,[288,274],309,[309,298,162],...
%     [309,274],309,[309,274],...
%     274,274,274,[298,162]};


% INTERP2=INTERP;
% csvfiles = ["Acer","Andre","Andre","Cen","Dian","Dian","Fer",...
%     "Gina","Gpa","Gpa","Gpa","Juan","Juan","Leti","Leti",...
%     "Luci","Lun","Mart","Mor","Mor","Muc","Pac",...
%     "Sol","Sol","Sol","Sor","Viv","Viv"];
numsvpi={299,[298,162],0,274,0,0,[288,274],0,309,...
    288,[309,298],162,[288,309],[309,274],0,288,299,...
    309,[274,309],274,0,288,[299,288],309,274,0,[288,274],0};

% rangvp={[1,7],[15,16],[16,17],0,[4,5],0,0,...
%     [1,5],[7,8],0,[14,17],[1,5],[8,14],[14,15],...
%     [15,16],[1,8],[9,13],[2,6],[6,7],0,[8,13],[1,8],...
%     [1,7],[12,13],[13,14],[4,5],0,[5,6],[1,9],[10,13],...
%     [13,14],[4,5],0,...
%     [6,10],[10,11],0};
rangvp={[1,7],[15,16],[16,17],[0,0],[4,5],[0,0],[0,0],...
    [1,5],[7,8],[0,0],[14,17],[1,5],[8,14],[14,15],...
    [15,16],[1,8],[9,13],[2,6],[6,7],[0,0],[8,13],[1,8],...
    [1,7],[12,13],[13,14],[4,5],[0,0],[5,6],[1,9],[10,13],...
    [13,14],[4,5],[0,0],...
    [6,10],[10,11],[0,0]};
% for i=1:length(ninterp)
iteraux=1;
cerocount=0;
for i=1:length(WEIGHTTABLES) % Hasta 28
  for j=1:length(numsvpi{i})
    jaux=1;
    a=rangvp{iteraux}(1);
    b=rangvp{iteraux}(2);
    if(a==0 || b==0)
      auxspl=0;
    else
      auxt=(WEIGHTTABLES{iteraux-cerocount}(a:b,1))';
      auxy=(WEIGHTTABLES{iteraux-cerocount}(a:b,2))';
      auxsamp=numsvpi{i}(j);
      auxspl=(SplCubLFGG(auxt,auxy,auxsamp))';
    end
    
    if(length(INTERP{i}(:))==1) % 1 2 o 3 interpolaciones
      auxspl=0;
      cerocount=cerocount+1;
      INTERP{i}=auxspl;
    end
    if(length(INTERP{i})==2)
      INTERP{i}(j)={auxspl};
%       INTERP{i}(j)={auxspl'};
    elseif(length(INTERP{i})>160 && length(INTERP{i})<310)
      INTERP{i}={auxspl};
%       INTERP{i}={auxspl'};
    end
  iteraux=iteraux+jaux;
  end
end
clear auxsamp auxspl auxt auxy;
% INTERP3=INTERP';

% % Sujetos de prueba para cada SuperParto
% % Dependiendo de cada SuperParto, hay un numero de vacas numcows
% % y como son pocos pues se escriben a mano
% % Parto #1 :   ["Sol","Lunita","Acerada"]
% % Parto #2 :   ["Gina","Juanita","Vivna","Dnita","Lucia","Sol","Pacha"]
% % Parto #3 :   ["Juanita","Guapa","Sol","Morocha","Fernda","Martina","Leticia"]
% % Parto #4 :   ["Viviana","Dianita","Morocha","Centavito","Leticia","Muchira","Soraya"]
% % Parto #5 :   ["Guapa","Andrea"]
% % Parto #6 :   ["Guapa","Andrea"]

csvfiles2 = csvfiles;
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
spi=[1,1,1,1,1,1];
% sp1=1;
% sp2=1;
% sp3=1;
% sp4=1;
% sp5=1;
% sp6=1;
FILENAMESTAB = {};
% csvfiles = ["Acer","Andre","Andre","Cen","Dian","Dian","Fer",...
%     "Gina","Gpa","Gpa","Gpa","Juan","Juan","Leti","Leti",...
%     "Luci","Lun","Mart","Mor","Mor","Muc","Pac",...
%     "Sol","Sol","Sol","Sor","Viv","Viv"];
lencsv=length(csvfiles);

for i=1:length(ninterp)
    if(numsvpi{i}~=0)
        for j=1:length(numsvpi{i})
            auxfun=string(numsvpi{i}(j));
            auxcsv=csvfiles2(m);
            auxtxt=(auxcsv+auxfun);
            FILENAMESTAB{m}=auxtxt;
            FILENAMESINTERP(m)=strcat(auxtxt,".csv");
            if(numsvpi{i}(j)==299)
                SP1INTERP{spi(1)} = INTERP{i}(j);
                SP1varnames{spi(1)}=auxtxt;
                spi(1)=spi(1)+1;
            end
            if(numsvpi{i}(j)==288)
                SP2INTERP{spi(2)} = INTERP{i}(j);
                SP2varnames{spi(2)}=auxtxt;
                spi(2)=spi(2)+1;
            end
            if(numsvpi{i}(j)==309)
                SP3INTERP{spi(3)} = INTERP{i}(j);
                SP3varnames{spi(3)}=auxtxt;
                spi(3)=spi(3)+1;
            end
            if(numsvpi{i}(j)==274)
                SP4INTERP{spi(4)} = INTERP{i}(j);
                SP4varnames{spi(4)}=auxtxt;
                spi(4)=spi(4)+1;
            end
            if(numsvpi{i}(j)==298)
                SP5INTERP{spi(5)} = INTERP{i}(j);
                SP5varnames{spi(5)}=auxtxt;
                spi(5)=spi(5)+1;
            end
            if(numsvpi{i}(j)==162)
                SP6INTERP{spi(6)} = INTERP{i}(j);
                SP6varnames{spi(6)}=auxtxt;
                spi(6)=spi(6)+1;
            end
            m=m+1;
        end
    end
end
% spi;
clear auxcsv auxfun auxtxt;
FilesInterp=FILENAMESINTERP';

SSJPINTERP={SP1INTERP,SP2INTERP,SP3INTERP,...
    SP4INTERP,SP5INTERP,SP6INTERP};

SSJPVARNAMES={SP1varnames,SP2varnames,SP3varnames,...
    SP4varnames,SP5varnames,SP6varnames};

SSJPINTERPAUX=SSJPINTERP;
SSJPINTERPAUX2=SSJPINTERP;

for i=1:length(SSJPINTERP)
    SSJPINTERPAUX{i}=SSJPINTERP{i}';
end
SSJPINTERPAUX;


svpiaux = 0; iteraux = 0; ssjpaux = 1;
ssjaux1 = cell2table(SSJPINTERPAUX{ssjpaux});
ssjaux2 = table2array(ssjaux1)';
ssjaux3 = array2table(ssjaux2); iters=0;
for i=1:length(ninterp) % Para c/Interp (28)
  
  if(numsvpi{i}~=0) % Revisar que NO sean 0
    jaux=0;
    for j=1:length(numsvpi{i}) %  #-Interpols
      jiter=1;
      %Sí nos pasamos de la cantidad de vacas
      if(iteraux+j<=length(SSJPINTERPAUX{ssjpaux})) 
        nameaux=char(SSJPVARNAMES{ssjpaux}{iteraux+j});
        ssjaux3.Properties.VariableNames{iteraux+j}=nameaux; % i+j-1
        jaux=j;
      else
          jaux=j-1;
      end
      iters=iters+jiter;
    end
    svpiaux=svpiaux+jaux;%
    iteraux=iteraux+jaux;%
    if(svpiaux==28)
      ssjaux4{ssjpaux}=ssjaux3;
    end
    if(svpiaux==3 || svpiaux==10 || svpiaux==17 ...
     || svpiaux==24 || svpiaux==26)
      ssjaux4{ssjpaux}=ssjaux3;
      ssjpaux = ssjpaux + 1;
      iteraux = 0;
      ssjaux1 = cell2table(SSJPINTERPAUX{ssjpaux});
      ssjaux2 = table2array(ssjaux1)'; % Dejar el (').
      ssjaux3 = array2table(ssjaux2);
    end
  end
end
ssjaux4;
nfiles=length(ssjaux4);
%=========================

% =========== Hasta aqui todo bien 30-01-23 =========

SSJTAB = (ssjaux4);
% SSJTAB = cell2table(SSJTAB);
% SSJTAB = table2array(ssjaux4);
% SSJTAB = SSJTAB.';
% SSJTAB = array2table(SSJTAB);
% SSJTAB = table2cell(SSJTAB);
nomtxt="PesVacP";
ext=".csv";

% for i=1:nfiles
%     aux = strcat(nomtxt,string(i));
%     aux = strcat(aux,ext);
%     aux = char(aux);
%     ssjaux4{i} = table2array(ssjaux4{i});
%     ssjaux4{i} = ssjaux4{i}';
%     ssjaux4{i} = array2table(ssjaux4{i});
%     % ssjaux4{i} = table2cell(ssjaux4{i});
% %     writetable(ssjaux4{i},aux,'WriteVariableNames',true);
% %     writetable(ssjaux4{i},aux,'WriteVariableNames',...
% %         {char(SP1varnames{1}), char(SP1varnames{2}), char(SP1varnames{3})});
%     writetable(ssjaux4{i},aux);
% % =========== Hasta aqui todo bien 30-01-23 =========
% %     writecell() %%%% BUSCAR ESTA FUNCION QUE SALIO POR AHI
% %     writetable() usar txt separa por comas a ver que sale
% end



%
% 
% ejex1=[0  60  120  180 210 240];
% ejey1=[416 421 403 444 478 391];
% spl1=SplCubLFGG(ejex1,ejey1,9)
% ejex1=[0 30 60 90 120 240 300 360 420 450 480];
% ejey1=[435 396 444 435 421 431 478 466 466 472 416];
% spl2=SplCubLFGG(ejex1,ejey1,11)
% spl1
% ejex1=[0 30 60 90 120 240 300 360 420 450 480];
% ejey1=[435 396 444 435 421 431 478 466 466 472 416];
% spl2=SplCubLFGG(ejex1,ejey1,17)
% ejex1=[0 60 90 120 150 180 270300 360 420 510 540];
% ejey1=[316 320 331 370 355 378 382 386 409 423 403 366];
% spl3=SplCubLFGG(ejex1,ejey1,19)
% ejex1=[0 60 90 120 150 180 270 300 360 420 510 540];
% ejey1=[316 320 331 370 355 378 382 386 409 423 403 366];
% spl3=SplCubLFGG(ejex1,ejey1,19)
% ejex1=[0 60 90 120 150 180 300 360 420 510 540];
% ejey1=[428];
% ejey1=[428 444 472 478 466 478 445 441 466 482 475];
% spl4=SplCubLFGG(ejex1,ejey1,18)
% spl4=SplCubLFGG(ejex1,ejey1,19)
% ejex1=[0 300 360 390 420 450 480 600 660 720 810 840];
% ejey1=[378 421 454 466 503 444 478 492 444 472 503 469];
% spl5=SplCubLFGG(ejex1,ejey1,29)
% ejex1=[0 60 90 120 150 180 270 300 360 420 510 540];
% ejey1=[435 458 478 448 500 553 561 536 600 541 515 532];
% spl6=SplCubLFGG(ejex1,ejey1,19)
% ejex1=[0 60 90 120 150 180 300 360 420 480 510 540];
% ejey1=[370 366 353 409 391 396 444 503 409 416 421 396];
% spl7=SplCubLFGG(ejex1,ejey1,19)
% ejex1=[0 60 120 150 180];
% ejey1=[382 416 466 441 382];
% spl8=SplCubLFGG(ejex1,ejey1,7)
% ejex1=[0 60 90 120 150 270 300 360 420 510];
% ejey1=[421 428 421 453 478 519 412 456 421 498];
% spl9=SplCubLFGG(ejex1,ejey1,18)
% ejex1=[0 30 60 90 120 210 240 300 360 420 450 480];
% ejey1=[515 503 511 498 498 541 473 528 565 515 551 492];
% spl10=SplCubLFGG(ejex1,ejey1,17)
% ejex1=[0 30 60 90 120 210 240 300 360 450];
% ejey1=[421 435 515 441 500 435 428 453 466 511];
% spl11=SplCubLFGG(ejex1,ejey1,16)
% ejex1=[0 60 120 150 180];
% ejey1=[464 396 475 409 391];
% spl12=SplCubLFGG(ejex1,ejey1,7)
% ejex1=[0 30 60 90 120 210 240 300 360 450 480];
% ejey1=[403 444 435 498 441 421 429 466 472 435 382];
% spl13=SplCubLFGG(ejex1,ejey1,17)
% ejex1=[0 60 120 150];
% ejey1=[370 340 370 427];
% spl14=SplCubLFGG(ejex1,ejey1,6)
% ejex1=[0 60 150 180];
% ejey1=[331 382 428 331];
% spl15=SplCubLFGG(ejex1,ejey1,7)
% ejex1=[0 60 120 180];
% ejey1=[466 435 444 453];
% spl16=SplCubLFGG(ejex1,ejey1,6)
% ejex1=[0 60 120 150];
% ejey1=[466 435 444 453];
% spl16=SplCubLFGG(ejex1,ejey1,6)
% ejex1=[0 60 90 120 150 180 270 300 360 420 510];
% ejey1=[444 444 444 503 435 511 472 483 553 560 620];
% spl17=SplCubLFGG(ejex1,ejey1,18)
% ejex1=[0 60 120 180 210 240];
% ejey1=[369 366 357 366 428 370];
% spl18=SplCubLFGG(ejex1,ejey1,9)
% ejex1=[0 60 90 120 150 180 300 360 420 480 510 540];
% ejey1=[370 366 353 409 391 396 444 503 409 416 421 396];
% spl7=SplCubLFGG(ejex1,ejey1,19)
%


% Para simulink del parto 3
path2 = "D:\LFGG\PUJ\Maestria_PUJ\Tesis maestria\HW-Pr1-Levenberg-Marquart\";
auxfilename2="ModSupVac";
nummods=6;
MODNAMES = strings(size(csvfiles)); % string Vector of size(# files)
for i=1:nummods
%     MODNAMES(i)=strcat(auxfilename2,csvfiles(i));
    MODNAMES(i)=strcat(strcat(path2,strcat(auxfilename2,num2str(i))),".csv");
end

MODTABLES=cell(1,length(csvfiles));
for i=1:nummods
    aux= YieldTablegenerator(MODNAMES,i);
    MODTABLES{i}=aux;
end
clear aux;

K1=0.7;
K2=0.036893;
K3=((44.75-19)/515);
P3FER_T=MODTABLES{1,3}(:,1);
P3FER_L=MODTABLES{1,3}(:,2);
P3FER_W=MODTABLES{1,3}(:,3);
P3FER_P=MODTABLES{1,3}(:,4);


