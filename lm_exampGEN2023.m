% Levenberg-Marquardt example/test - With Comp Cientif project 1
%   Henri Gavin, Dept. Civil & Environ. Engineering, Duke Univ. 2 May 2016
%   modified from: ftp://fly.cnuce.cnr.it/pub/software/octave/leasqr/
%   Press, et al., Numerical Recipes, Cambridge Univ. Press, 1992, Chapter 15.
%
clc
close all
% clear
% hold off
randn('seed',0);	% specify a particular random sequence for msmnt error
% *** For this demonstration example, simulate some artificial measurements by
% *** adding random errors to the curve-fit equation.  
global	example_number

example_number = 1;			  % which example to run: 1 2 3 or 4  
consts = [ ];                 % optional vector of constants
%================================================================
%========= Levenberg Marquart Script  with my data.==============
%================================================================
% filename = "D:\LFGG\PUJ\Maestria_PUJ\Tesis maestria\HW-Pr1-Levenberg-Marquart\PrFCSV.csv";

%================================================================
%====== Levenberg Marquart Script  with my CSV data. ============
%================================================================
filename = "D:\LFGG\PUJ\Maestria_PUJ\Tesis maestria\DataSet SENA 2022\";
csvfiles = ["SVNETP1","SVNETP2","SVNETP3","SVNETP4","SVNETP5","SVNETP6"];
% Sujetos de prueba para cada SuperParto
% Dependiendo de cada SuperParto, hay un numero de vacas numcows
% y como son pocos pues se escriben a mano
% Parto #1 :   ["Sol","Lunita","Acerada"]
% Parto #2 :   ["Gina","Juanita","Vivna","Dnita","Lucia","Sol","Pacha"]
% Parto #3 :   ["Juanita","Guapa","Sol","Morocha","Fernda","Martina","Leticia"]
% Parto #4 :   ["Viviana","Dianita","Morocha","Centavito","Leticia","Muchira","Soraya"]
% Parto #5 :   ["Guapa","Andrea"]
% Parto #6 :   ["Guapa","Andrea"]
SUBS={["Sol","Lunita","Acerada"], ...
    ["Gina","Juanita","Viviana","Dianita","Lucia","Sol","Pacha"], ...
    ["Juanita","Guapa","Sol","Morocha","Fernanda","Martina","Leticia"], ...
    ["Viviana","Dianita","Morocha","Centavito","Leticia","Muchira","Soraya"], ...
    ["Guapa","Andrea"], ...
    ["Guapa","Andrea"]};
% Usamos una serie de colores distintos para cada plot de cada parto
COLORS =["rgb","rgbcmyk","rgbcmyk",...
    "rgbcmyk","cm","cm"];
lencsv = length(csvfiles);
FILENAMES = strings(size(csvfiles));
for i=1:length(csvfiles)
FILENAMES(i)=strcat(strcat(filename,csvfiles(i)),".csv");
end
% Creamos las tablas de produccion de leche de cada Super parto
YIELDTABLES=cell(1,lencsv);
for i=1:lencsv
    aux= YieldTablegenerator(FILENAMES,i);
    YIELDTABLES{i}=aux;
end
LENT=zeros(1,lencsv);
T=cell(1,lencsv);
for i=1:lencsv
    [aux7,aux8] = YTtimes(YIELDTABLES,i);
    LENT(i)=aux8;
    T{i}=aux7;
end

ncows=zeros(1,lencsv);
for i=1:lencsv
    % Size() inidica las filas y columnas de cada tabla
    % Solo me interesan las columnas -1 una de ellas que es de las muestras de tiempo
    % y lo divido entre 3, pues tengo valores NETOS, AM Y PM
    % para una misma vaca
    ncows(i)= (size(YIELDTABLES{i},2)-1)/3;
end

% Npnt = length(t); % number of data points T{k}

SVY={{}};
MESY={{}};
for i=1:lencsv
    [yvp,MEY] = YTyields(YIELDTABLES,i,ncows(i));
    SVY{i}=yvp;
    MESY{i}=MEY;
end
YT0 = {{}};
YMAX = {{}};
TYMAX = {{}};
YMIN = {{}};
TYMIN = {{}};
P_A = {{}};
P_B = {{}};
P_C = {{}};
PHI0T = {{}};
PHI0G = {{}};
PHI_MIN = {{}};
PHI_MAX = {{}};
RANDOM = cell(1,lencsv);


Npar = 3; % Quantity of Params (a,b,c)
msmnt_err = 0.125; % Lets add an error to data (human error for example)
weight = 1/msmnt_err^2;

initpiece=30;
initstart=5;
endpiece=40;
for i=1:lencsv
    for j=1:ncows(i)
        [massimo,indmas] =...
         max(SVY{i}{j}(initstart:(3*initpiece)));
%       Le sumo los 5 que exluí y le resto 1
%       por ser inlcusivo el limite
%       indmas+(initstart-1)
        indmas = indmas+(initstart-1);
%         [minimo,indmin] = min(SVY{i}{j}(SVY{i}{j}>0));
        % buscamos el primer valor que no sea 0
        % para usarlo como Prod_Ini = Par_A en Wood
                
        finaux = SVY{i}{j}(end-endpiece:end);
        edgeaux = find(finaux>1,endpiece);
        edgeaux2 = finaux(end-endpiece:end-(endpiece-((edgeaux(end))-1)));
        [minimo,indmin2] = min(edgeaux2(edgeaux2>1));
        auxfound = find(finaux==minimo,1);
        finminimo = finaux(auxfound);
%         indfinminimo = length(SVY{i}{j})-(endpiece+indmin2-1);
        indfinminimo = max(find(SVY{i}{j}==minimo,endpiece));
%         (Escoge al primero de los repetidos)
%         indfinminimo = (find(SVY{i}{j}==minimo2,1)); 
        
        iniaux = SVY{i}{j}(4:initpiece);
        inilim = find(iniaux>0,1); % El primero >0
        YT0{i,j} = iniaux(inilim);
        
        YMAX{i,j} = massimo;

        TYMAX{i,j} = indmas;
        YMIN{i,j} = finminimo;
%         YMIN{i,j} = unique(YMIN{i,j});
        TYMIN{i,j} = indfinminimo;
        
        P_A{i,j} = YT0{i,j}(YT0{i,j}>0);
        P_B{i,j} = log(massimo/YT0{i,j})/log(indmas);
        appleaux = (finminimo/YT0{i,j}).*(1./(indfinminimo.^(P_B{i,j})));
        P_C{i,j} = (-1)*(log(appleaux))/(indfinminimo);
        
        % Agregamos ruido a los valores
        RANDOM{i} = randn(length(T{i}),1);
        SVY{i}{j} = SVY{i}{j} + msmnt_err*RANDOM{i};
        
%         [dim1, dim2] = size(SVY{i}{j});
        RANDGUESS{i} = randn(1,1);
        % OJO que PHI0T y PHI0G deben estar Transpuestos
        PHI0T{i,j} = [P_A{i,j} P_B{i,j} P_C{i,j}]'; 
        PHI0G{i,j} = PHI0T{i,j};
        PHI0G{i,j}(1) = ...
         round(PHI0G{i,j}(1),0)+ msmnt_err*RANDGUESS{i};
        PHI0G{i,j}(2) = ...
         round(PHI0G{i,j}(2),2)+ (msmnt_err*RANDGUESS{i}/10);
        PHI0G{i,j}(3) = ...
         round(PHI0G{i,j}(3),3)+ (msmnt_err*RANDGUESS{i}/100);
        PHI_MIN{i,j} = -10*abs(PHI0G{i,j});
        PHI_MAX{i,j} = 10*abs(PHI0G{i,j});
%         NPAR = length(PHI0T(1,:));;
        
    end
end

PHI0T; % Valores teoricos
PHI0G; % Valores guess

for k=1:lencsv
    if(k==1)
        name = strcat('Prod. Neta - Parto #',num2str(k));
%         fig = k+(3*lencsv);
        figure('Name',name)
        fils = 1; cols = 3;
    end
    if(k>1) && (k<5)
        if(k==2)
            name = strcat('Prod. Neta - Parto #',num2str(k));
        end
        if(k==3)
            name = strcat('Prod. Neta - Parto #',num2str(k));
        end
        if(k==4)
            name = strcat('Prod. Neta - Parto #',num2str(k));
        end
%         name = ('Prod. Neta - Partos #' + num2str(k));
        fils = 2; cols = 4;
%         fig = k+(3*lencsv);
        figure('Name',name)
    end
    if(k>=5)
        if(k==5)
            name = strcat('Prod. Neta - Parto #',num2str(k));
        end
        if(k==6)
            name = strcat('Prod. Neta - Parto #',num2str(k));
        end
%         name = ('Prod. Neta - Partos #' + num2str(k));
%         fig = k+(3*lencsv);
        figure('Name',name)
        fils = 1; cols = 2;
    end
    for I = 1:length(SUBS{k})
        tI = T{k};
        yI = SVY{k}{I};
        subplot(fils,cols,I)
        scatter(tI,yI,5,COLORS{k}(I),'filled')
        hold on
        
%         plot(T{k},model(PHIFS{k},TDASHED{k}),':',...
%         'color',[.5 .5 .5],'LineWidth',3.5) 
        %===================================================
        legend(SUBS{k}(I))
%         legend(SUBS{k}(I),strcat("Ajuste LM de ",SUBS{k}(I)))
        legend('Location','best','Orientation','horizontal');
        lgd = legend;
        lgd.NumColumns = 2;

        set(gca,'Color',[0.85 0.85 0.85]);
        grid on
        xlabel('Tiempo (días)')
        ylabel('Producción de leche [kg]')
        title(['{\bf Parto #}',num2str(k)])
    end
    
end

% PHI0T = PHI0T';
% P_FIT = PHI0T;
% CHI_SQ = PHI0T;
% SIGMA_P = PHI0T;
% SIGMA_Y = PHI0T;
% CORR = PHI0T;
% R_SQ = PHI0T;
% CVG_HST = PHI0T;
% LM_FIT = PHI0T;
% PARS_PERCENTAGE = PHI0T;

P_FIT = {{}};
CHI_SQ = {{}};
SIGMA_P = {{}};
SIGMA_Y = {{}};
CORR = {{}};
R_SQ = {{}};
CVG_HST = {{}};
LM_FIT = {{}};
PARS_PERCENTAGE = {{}};
lm_uses=7;

for k=1:lencsv
    
    for I = 1:length(SUBS{k})
        %===================================================
        opts = [3, 40*Npar, 1e-3, 1e-3, 1e-1,...
            1e-1, 1e-2, 12, 10, 1];
        p_init = PHI0G{k,I};
        t = T{k};
        y_dat = SVY{k}{I};
        p_min = PHI_MIN{k,I};
        p_max = PHI_MAX{k,I};
        
        [p_fit, Chi_sq, sigma_p, sigma_y, corr, R_sq, cvg_hst] = ...
        lm('lm_func', p_init, t, y_dat, weight,...
        -0.01, p_min, p_max, consts, opts);
        
        % === Creamos la y=f(x) de wood con p_fit
        y_fit = lm_func(t,p_fit,consts); 
        % ========================================
        fn = sprintf('lm_examp_%d',example_number);
        lm_incr=lm_plotstes ( t, y_dat, y_fit, sigma_y,...
            cvg_hst, fn, lm_uses,SUBS{k}(I),k);
        lm_uses = lm_incr;
        P_FIT{k,I} = p_fit;     % 3 valores
        CHI_SQ{k,I} = Chi_sq';  % 1 valor
        SIGMA_P{k,I} = sigma_p; % 3 valores
        SIGMA_Y{k,I} = sigma_y'; % (n-muestras) valores
        CORR{k,I} = corr';       % 3x3 matrix
        R_SQ{k,I} = R_sq';       % 1 valor
        CVG_HST{k,I} = cvg_hst'; % 6x42 matrix?????
        LM_FIT{k,I} = lm_func(T{k},p_fit,consts)'; %6X7 cell
        
        PARS_PERCENTAGE{k,I} =...
            100*abs(SIGMA_P{k,I}./P_FIT{k,I}); % 3 valores
        
        %===================================================
    end
end

% disp('                                                        ')
% disp('======================================================')

%==============================================
%       AQUI VAMOS A MOSTRAR LA TABLA 
%         CON TODOS LOS PARÁMETROS
%           OBTENIDOS CON LM_FIT
% ........................................
%==============================================
% SUBS2={["Sol","Lun","Acer"]', ...
%     ["Gina","Juan","Viv","Dian","Luci","Sol","Pac"]', ...
%     ["Juan","Gpa","Sol","Mor","Fer","Mart","Leti"]', ...
%     ["Viv","Dian","Mor","Cent","Leti","Muc","Sor"]', ...
%     ["Gpa","Andre"]', ...
%     ["Gpa","Andre"]'}';

disp('                                                        ')
disp('                                                        ')

%==============================================
%        INCLUYENDO A SIGMA_P
%==============================================

for k=1:lencsv
    disp('======================================================')
    disp(['====================== Parto #',num2str(k),' ======================'])
    disp('======================================================')
    disp('==  Teorico   Ajuste    (?_{p}/Ajuste)[%]  =======')
%     disp('==  inicial   Teorico   Ajuste    ?_{p}    (?_{p}/Ajuste)[%]  =======')
%     disp('== initial     true      fit     \sigma_{p}    percent ==')
    disp('======================================================')
    disp('                                                        ')
    for I = 1:length(SUBS{k})
        %===================================================
        disp([  PHI0T{k,I}  P_FIT{k,I} PARS_PERCENTAGE{k,I} ])
%         disp([ PHI0G{k,I}  PHI0T{k,I}  P_FIT{k,I} SIGMA_P{k,I} PARS_PERCENTAGE{k,I} ])
        %     disp([ PHI0G{k,:}'  PHI0T{k,:}'  P_FIT{k,:}' SIGMA_P{k,:}' PARS_PERCENTAGE{k,:}' ])
        %     ["\Chi^{2}" "R^{2}";CHI_SQ{k,:} R_SQ{k,:}]
        %     ["\Chi^{2}" "R^{2}";CHI_SQ(:) R_SQ(:)]
    end
end

%==============================================
%        SIN INCLUIR SIGMA_P
%==============================================
% 
% for k=1:lencsv
%     disp('==================================================')
%     disp(['=================== Parto #',num2str(k),' ====================='])
%     disp('==================================================')
%     disp('===  inicial  Teorico    Ajuste    %Error  =======')
%     disp('==================================================')
%     disp('                                                        ')
% %     disp('===========================================================')
% %     disp(['======================= Parto #',num2str(k),' =========================='])
% %     disp('==========================================================')
% %     disp('===  inicial  Teorico    Ajuste    %Error   Sujeto  =======')
% %     disp('===========================================================')
% %     disp('                                                        ')
%     for I = 1:length(SUBS{k})
%         %===================================================
% %         disp([  PHI0G{k,I}  PHI0T{k,I}  P_FIT{k,I} PARS_PERCENTAGE{k,I} SUBS2{k,I} ])
%         disp([  PHI0G{k,I}  PHI0T{k,I}  P_FIT{k,I} PARS_PERCENTAGE{k,I} ])
% %         disp([ PHI0G{k,I}  PHI0T{k,I}  P_FIT{k,I} SIGMA_P{k,I} PARS_PERCENTAGE{k,I} ])
%         %     disp([ PHI0G{k,:}'  PHI0T{k,:}'  P_FIT{k,:}' SIGMA_P{k,:}' PARS_PERCENTAGE{k,:}' ])
%         %     ["\Chi^{2}" "R^{2}";CHI_SQ{k,:} R_SQ{k,:}]
%         %     ["\Chi^{2}" "R^{2}";CHI_SQ(:) R_SQ(:)]
%     end
% end

YMAX;
TYMAX;
YMIN;
TYMIN;
P_A;
P_B;
P_C;
PHI0T;
PHI0G;

% Aproximación de producción segun:
%    parametros Teoricos
%    parametros LM
%    parametros s_fit
%    parametros M_fit
%    parametros ME_fit

INTEG_T={{}};
MY_T={{}};
INTEG_LM={{}};
Pars_T={{}};
Pars_LM={{}};
Pars_SF={{}};
Pars_FM={{}};
Pars_FE={{}};
INTEG_S={{}};
INTEG_FM={{}};
INTEG_ME={{}};

%
%     Es necesario correr AnaMixEffGenBeta2.m para que salgan
%     Todos los parametros.
% 
% 
% 
% for k=1:lencsv
%     for I = 1:length(SUBS{k})
%         aT = PHI0T{k,I}(1);
%         bT = PHI0T{k,I}(2);
%         cT = PHI0T{k,I}(3);
%         Pars_T{k,I}=[aT,bT,cT];
%         INTEG_T{k,I}=...
%          aT.*(T{k}.^(bT)).*(exp((-1*cT).*T{k}));
%         MY_T{k,I} = (round(((sum(INTEG_T{k,I}))),3));
%         
%         aLM = P_FIT{k,I}(1);
%         bLM = P_FIT{k,I}(2);
%         cLM = P_FIT{k,I}(3);
%         Pars_LM{k,I}=[aLM,bLM,cLM];
%         INTEG_LM{k,I}=...
%          aLM.*(T{k}.^(bLM)).*(exp((-1*cLM).*T{k}));
%         MY_LM{k,I} = (round(((sum(INTEG_LM{k,I}))),3));
%                 
%         aFM = PHIFM{k}(1,I);
%         bFM = PHIFM{k}(2,I);
%         cFM = PHIFM{k}(3,I);
% %         Pars_SF{k,I}=[aSF,bSF,cSF];
%         Pars_FM{k,I}=[aFM,bFM,cFM];
%         INTEG_FM{k,I}=...
%          aFM.*(T{k}.^(bFM)).*(exp((-1*cFM).*T{k}));
%         MY_FM{k,I} = (round(((sum(INTEG_FM{k,I}))),3));
%         
%         aME = PHIMEFIN{k}(1,I);
%         bME = PHIMEFIN{k}(2,I);
%         cME = PHIMEFIN{k}(3,I);
%         Pars_ME{k,I}=[aME,bME,cME];
%         INTEG_ME{k,I}=...
%          aME.*(T{k}.^(bME)).*(exp((-1*cME).*T{k}));
%         MY_ME{k,I} = (round(((sum(INTEG_ME{k,I}))),3));
%     end
%     aFS = PHIFS{k}(1);
%     bFS = PHIFS{k}(2);
%     cFS = PHIFS{k}(3);
%     INTEG_FS{k}= aFS.*(T{k}.^(bFS)).*(exp((-1*cFS).*T{k}));
%     MY_FS{k} = (round(((sum(INTEG_FS{k}))),3));
% end
% MY_T=MY_T';
% MY_LM=MY_LM';
% MY_FM=MY_FM';
% MY_ME=MY_ME';
% 
% ACURVLM=vpa([sum(INTEG_LM{3,1}), sum(INTEG_LM{3,2}), sum(INTEG_LM{3,3}), sum(INTEG_LM{3,5})]')
% ACURVT=vpa([sum(INTEG_T{3,1}), sum(INTEG_T{3,2}), sum(INTEG_T{3,3}), sum(INTEG_T{3,5})]')
% [ACURVLM; ACURVT]
% [ACURVLM,  ACURVT]
% %%
% % close(7:90)
% % close(1:6)
% 
% 
% 
% % global p_true_lm 
% % p_true_lm = p_true
% 
% % lm_examp.m  ---------------------------------------------------------------- 
% %