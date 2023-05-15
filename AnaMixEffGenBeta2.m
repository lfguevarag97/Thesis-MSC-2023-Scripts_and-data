clc
close all
% clear all
hold off
% randn('seed',0);

filename = "D:\LFGG\PUJ\Maestria_PUJ\Tesis maestria\DataSet SENA 2022\";
csvfiles = ["SVNETP1","SVNETP2","SVNETP3",...
    "SVNETP4","SVNETP5","SVNETP6"];
lencsv=length(csvfiles); % 6 archivos
FILENAMES = strings(size(csvfiles)); % string Vector of size(# files)
%cargamos los archivos con extension csv
for i=1:lencsv
    FILENAMES(i)=strcat(strcat(filename,csvfiles(i)),".csv");
end
% Creamos las tablas de produccion de leche de cada Super parto
YIELDTABLES=cell(1,length(csvfiles));
for i=1:lencsv
    aux= YieldTablegenerator(FILENAMES,i);
    YIELDTABLES{i}=aux;
end
% Aqui ya tenemos 6 tablas, cada una con las columnas ( todas las vacas)
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
% Aqui T es la cantidad de muestras de tiempo usadas para las vacas
% del parto_i, dependiendo del numero de vacas usadas para cada parto
% En el parto 1 se Usan solo 3/9 vacas por lo que el vector T para ME
% Es de 299*3 = 897y así sucesivamente para los otros partos
MET=cell(1,lencsv);
ncows=zeros(1,lencsv);
for i=1:lencsv
    % Size() inidica las filas y columnas de cada tabla
    % Solo me interesan las columnas -1 que es de las muestras de tiempo
    % y lo divido entre 3, pues tengo valores NETOS, AM Y PM
    % para una misma vaca
    ncows(i)= (size(YIELDTABLES{i},2)-1)/3;
    % Luego para Mixed Effects tengo que repetir las muestras de tiempo
    % dependiendo del numero de vacas que haya en ese parto
    MET{i}=repmat(T{i},ncows(i),1);
end
% SVY es una cell que guarda
SVY={{}};
MESY={{}};
for i=1:lencsv
    [yvp,MEY] = YTyields(YIELDTABLES,i,ncows(i));
    SVY{i}=yvp;
    MESY{i}=MEY;
end
% Aqui tengo como resultado:
%  yyy{j} --> pasa a ser SVY, que guarda una tabla de producciones NETAS
% mientras que mey{j} pasa a ser --> MESY, que guarda esos valores
% en un unico array 1D de
% length(vacasNET*(n-muestras)) EJ 897=3vacas*299 muestras



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
% COLORS2={{}};
% COLORS2 =[{[1 0 0],[0 1 0],[0 0 1]},...
%     {[1 0 0],[0 1 0],[0 0 1],[0 1 1],[1 0 1],[0.9290 0.6940 0.1250],[0 0 0]},...
%     {[1 0 0],[0 1 0],[0 0 1],[0 1 1],[1 0 1],[0.9290 0.6940 0.1250],[0 0 0]},...
%     {[1 0 0],[0 1 0],[0 0 1],[0 1 1],[1 0 1],[0.9290 0.6940 0.1250],[0 0 0]},...
%     {[0 1 1],[1 0 1]},...
%     {[0 1 1],[1 0 1]}];

% Para mixed effects necesitamos repetir T y los registros
% pero para efectos de ploteo, tambien necesitamos que las primeras
% N-muestras sean asociadas a la primera vaca EJ "SOL" 299 veces y lo mismo
% con las otras vacas..... ESO PASA CON SUBi
SUBi={{}};
% En SUBJECTS YA TENEMOS EL VECTOR 1D con SOL, SOL SOL, ...., Lina, Lina...
% para el total de 897 muestras
SUBJECTS={{}};
for i=1:lencsv
    for j=1:ncows(i)
        SUBi{i,j}=strings([1,length(T{i})]);
        SUBi{i,j}(:)=SUBS{i}(j);
        aux20=cat(1,SUBi{i,:});
        aux20=aux20';
        aux20=reshape(aux20,1,[]);
    end
    SUBJECTS{end+i-1}=aux20;
end

emptyCells = cellfun(@isempty,SUBJECTS);
%  remove empty cells por si las hay. Esto pasaba algunas veces que cogia
% y agregaba valores en vacio [] porque la matriz (tabla) debia tener igual
% longitud, pero para cada vaca hay distinta cantidad de muestras
SUBJECTS(emptyCells) = [];
%=================================================
colors = 'rgbcmyk';

% subs=["Sol","Lunita","Acerada"];
subs=SUBS{1}; % subs=SUBS{1} es una linea usada para corroborar que 
% SUBS alamacena los nombres de las numcows-vacas de cada parto
% [3,7,7,7,2,2]

% subject=[sub1 sub2 sub3]'; % pacientes/vacas
subject=SUBJECTS{1}'; % subject=SUBJECTS{1}' es una linea usada para 
% corroborar que SUBJECTS alamacena el vector de pacientes de cada parto
% repetidos para el plot de Mixed Effects.


%===================================
met1=MET{1}; met2=MET{2}; met3=MET{3};
met4=MET{4}; met5=MET{5}; met6=MET{6};
%===================================


%=== Modelo Gamma Invertido de Wood =========
model = @(vphi,vt)...
    ((vphi(1)*(vt.^vphi(2))).*(exp(-1*vt*vphi(3))));
%============================================

% Valores Iniciales de los parametros a,b,c para cada superparto
% Son solo 3 pues se intenta sacar un modelo de super vaca que describa a
% todas las vacas al mismo tiempo, por lo que solo se necesitan 3
% parametros. Evidentemente no es el mejor pues hay vacas que se alejan del
% comportamiento de las otras vacas

PHI0s={{}};
phi0y1 = [8.80000000000000 0.258779312733385 0.00645854563630996];
phi0y2 = [14.4000000000000 0.140429834878307 0.00828131309336635];
phi0y3 = [15.4000000000000 0.0147232568207064 0.00983608423654219];
phi0y4 = [10.5428571428571 0.369956625683170 0.00840121649743404];
phi0y5 = [13.9000000000000 0.111561226186677 0.00815509641691642];
phi0y6 = [19.8000000000000 0.111561226186677 0.00463322620434574];

%=======================================
%===== REVISAR ABCSUPERVNET.m por si las ... 15 Ene 2023, uso estos valores
% phi0y1 = [8.9333     0.1986    0.0058];
% phi0y2 = [13.3000    0.2038    0.0111];
% phi0y3 = [15.3429    0.1907    0.0104];
% phi0y4 = [10.0857    0.2070    0.0117];
% phi0y5 = [10.4000    0.1925    0.0133];
% phi0y6 = [18.5000    0.0869    0.0029];
%=======================================
%=======================================

PHI0s{1}=phi0y1;
PHI0s{2}=phi0y2;
PHI0s{3}=phi0y3;
PHI0s{4}=phi0y4;
PHI0s{5}=phi0y5;
PHI0s{6}=phi0y6; 

% DE AQUI EN ADELANTE CALCULAREMOS PARAMETROS PARA ESTIMAR MODELOS
% ya sea que usemos un unico modelo(Phi SINGLE) Para representar
% a todas las vacas o que vayamos haciendo pruebas de ReFitted, ReFitted
% con patron, o con el NonLinearMixedEffectsReFittedPatron (NLME2RFPAT)
% Entre otros...

%Todos los parametros para cada parto
% (#param (Wood son 3) * #subjects [3,7,7,7,2,2]) for each yield
PHIFS={{}}; 
RESIDFS={{}}; %(#t*#subjects) for each yield

% Para cada parto hay un numero total de muestras repetidas en el vector 1D
% Estos valores serían algo así como [897,2016,2163,1918,596,324]
% Cantidad de muestras totales para los 
numObs=zeros(1,lencsv);  

% Para numcows- vacas hay 3 parametros a,b,c, por lo que tengo que calcular
% el numero de parametros totales para cada vaca individualmente
% osea que para el priemr superparto tengo 3 vacas y 3 parametros para cada
% vaca, osea un total de 9 vacas
numParams=zeros(1,lencsv);
mses=zeros(1,lencsv); % MSEs para cada parto
df=zeros(1,lencsv);
escal=zeros(1,lencsv);

% Para plotear las regresiones obtenidas para cada vaca de cada parto
% usamos TDASHED, Pues es una linea punteada que se calcula usando el
% tiempo tdashed que varia para cada vaca
TDASHED={{}};
% figaux=1
ngroups=length(unique(ncows));

%================================================
% Gráficas SuperVacas con Fit Unico
%    PHIFS{k}= 3 Parametros para cada parto
%    RESIDFS{k}= Residuos de cada parto
%================================================

for k=1:lencsv
    TDASHED{k} = 1:0.1:length(T{k});
    [phifits,residfits] = nlinfit(MET{k},MESY{k},model,PHI0s{k}); %(nv*np) 
    % Params de cada fit de supervaca a una sola curva de ajuste
    PHIFS{k}=phifits; 
    RESIDFS{k}=residfits; 
    
    if(k==1)
        fig=1;
        figure(fig)
        fils=2;cols=2;
        subplot(fils,cols,1)
    end
    if(k>1) && (k<5)
        fils=3;cols=4;
        fig=2;
        figure(fig)
        if(k==2)
            subplot(fils,cols,1)
        end
        if(k==3)
            subplot(fils,cols,5)
        end
        if(k==4)
            subplot(fils,cols,9)
        end
    end
    if(k>=5)
        fig=3;
        figure(fig)
        fils=2;cols=4;
        if(k==5)
            subplot(fils,cols,1)
        end
        if(k==6)
            subplot(fils,cols,5)
        end
    end
    
    gscatter(MET{k},MESY{k},SUBJECTS{k},COLORS(k));
    xlabel('Tiempo (días)');
    ylabel('Producción de leche (kg/día)');
    title(['{\bf Producción neta "Super Vaca" - Parto #}',num2str(k)]);
%     xlabel('Time (days)');
%     ylabel('Milk Production (kg/day)');
%     title(['{\bf Milk Yield SuperCow Birth #}',num2str(k)]);
    
    
    grid on
    hold on
    % Ploteamos  todos los fits unicos para cada supervaca
    plot(TDASHED{k},model(PHIFS{k},TDASHED{k}),':',...
        'color',[.5 .5 .5],'LineWidth',3.5) 
    hold on
%     legend([SUBS{k},'Single Fit'])
    legend([SUBS{k},'Ajuste único'])
    legend('Location','best','Orientation','horizontal');
    lgd = legend;
    lgd.NumColumns = 2;
    
    set(gca,'Color',[0.85 0.85 0.85]);

 
    numObs(k) = length(MET{k});
    numParams(k) = length(PHI0s{k});
    df(k) = numObs(k)-numParams(k);
    escal(k) = (RESIDFS{k}'*RESIDFS{k}) ;
    mses(k) = escal(k)/df(k); % mse single for each birth (6)
    hold on
    
    %==========================================
    % PARA BLOX PLOTS SIN EFFECTOS INDIVIDUALES
    %==========================================
    if(k==1)
        fig=1+lencsv;
        figure(fig)
        fils=2;cols=1;
        subplot(fils,cols,1)
    end
    if(k>1) && (k<5)
        fils=2;cols=3;
        fig=2+lencsv;
        figure(fig)
        if(k==2)
            subplot(fils,cols,1)
        end
        if(k==3)
            subplot(fils,cols,2)
        end
        if(k==4)
            subplot(fils,cols,3)
        end
    end
    if(k>=5)
        fig=3+lencsv;
        figure(fig)
        fils=2;cols=2;
        if(k==5)
            subplot(fils,cols,1)
        end
        if(k==6)
            subplot(fils,cols,2)
        end
    end

    h = boxplot(RESIDFS{k},SUBJECTS{k}','colors',COLORS{k},'symbol','o');
    set(h(~isnan(h)),'LineWidth',2)
    hold on
    boxplot(RESIDFS{k},SUBJECTS{k}','colors','k','symbol','ko')
    grid on
    xlabel('Sujetos')
    ylabel('Residuos')
    title(['{\bf Sin efectos específicos - Parto #}',num2str(k)]);
    
%     xlabel('Subjects')
%     ylabel('Residuals')
%     title(['{\bf Without Subject Specific Effects - Birth #}',num2str(k)]);
    
    set(gca,'Color',[0.85 0.85 0.85]);
    
end

NUMOBS=zeros(1,lencsv);
NUMPARAMS=zeros(1,lencsv);
DF=zeros(1,lencsv);
MSEM=zeros(1,lencsv);
ESCAL=zeros(1,lencsv);

%========================================================
% Gráficas SuperVacas con Fit Multiple
%    PHIFM{k}= 3 Parametros de cada vaca de cada parto
%    RESIDFM{k}= Residuos de cada vaca de cada parto
%========================================================
% disp(['==========  MSE  ==============='])
% disp(['===  A-Unico      A-M    ========'])
%     disp(['=====  MSE Yield Birth #',num2str(j),' ====='])
% disp('     (3-pars)    (3*#v)-pars')
for j=1:lencsv
    % %     PHI2 = zeros(3,3); % 3 params - 3 cows
    % %     RES2 = zeros(299,3); % 299 values for 3 cows
    PHIFM{j}=zeros(numParams(j),length(SUBS{j})); %(#param*#subjects) for each yield
    RESIDFM{j}=zeros(length(T{j}),length(SUBS{j})); %(#t*#subjects) for each yield
    for i=1:length(SUBS{j})
        titerated = T{j};
        yiterated = SVY{j}{i};
        [PHIFM{j}(:,i),RESIDFM{j}(:,i)] =...
        nlinfit(titerated,yiterated,model,PHI0s{j});
    end
    NUMPARAMS(j) = numel(PHIFM{j});
    NUMOBS(j)=length(MET{j});
    DF(j) = NUMOBS(j) - NUMPARAMS(j);
    ESCAL(j)=(RESIDFM{j}(:)'*RESIDFM{j}(:));
    MSEM(j) = ESCAL(j)/DF(j);
% %     disp(['=====  Parto #',num2str(j),' ====='])
%     disp(['      ',num2str(round(mses(j),3)),'        ',num2str(round(MSEM(j),3)),...
%         '   ===== Parto #',num2str(j),' ====='])
end


% for j=1:lencsv
%     
% end

%==================================
% Graficas de regresiones multiples
% .................................
% Curvas de ajuste para cada vaca,
% en cada grupo de parto
%==================================

for k=1:lencsv  
        
    if(k==1)
        fig=1;
        figure(fig)
        fils=2;cols=2;
        subplot(fils,cols,2)
    end
    if(k>1) && (k<5)
        fig=2;
        figure(fig)
        fils=3;cols=4;
        if(k==2)
            subplot(fils,cols,2)
        end
        if(k==3)
            subplot(fils,cols,6)
        end
        if(k==4)
            subplot(fils,cols,10)
        end
    end
    if(k>=5)
        fig=3;
        figure(fig)
        fils=2;cols=4;
        if(k==5)
            subplot(fils,cols,2)
        end
        if(k==6)
            subplot(fils,cols,6)
        end
    end
%     subplot(fils,cols,1)
%     gscatter(MET{k},MESY{1,k},SUBJECTS{k},COLORS(k));
    gscatter(MET{k},MESY{k},SUBJECTS{k},COLORS(k));
    legend('Location','best','Orientation','horizontal');
    lgd = legend;
    lgd.NumColumns = 2;
    xlabel('Tiempo (días)');
    ylabel('Producción de leche (kg/día)');
    title(['{\bf Producción neta "Super Vaca" - Parto #}',num2str(k)]);
    
%     xlabel('Time (days)');
%     ylabel('Milk Production (kg/day)');
%     title(['{\bf Milk Yield "Super Cow" - Birth #}',num2str(k)]);
    
    grid on
    hold on
    extraleg=[""];
    for I = 1:length(SUBS{k})
        plot(TDASHED{k},model(PHIFM{k}(:,I),TDASHED{k}),...
            'Color',COLORS{k}(I));
        extraleg(I)=strcat("Ajuste de ",SUBS{k}(I));
%         extraleg(I)=strcat(SUBS{k}(I),"'s Fit");
    end
    legend([SUBS{k},extraleg])
    legend('Location','best','Orientation','horizontal');
    lgd = legend;
    lgd.NumColumns = 2;
    
    set(gca,'Color',[0.85 0.85 0.85]);

    %==========================================
    % PARA BLOX PLOTS SIN EFFECTOS INDIVIDUALES
    %==========================================
    if(k==1)
        fig=1+lencsv;
        figure(fig)
        fils=2;cols=1;
        subplot(fils,cols,2)
    end
    if(k>1) && (k<5)
        fils=2;cols=3;
        fig=2+lencsv;
        figure(fig)
        if(k==2)
            subplot(fils,cols,4)
        end
        if(k==3)
            subplot(fils,cols,5)
        end
        if(k==4)
            subplot(fils,cols,6)
        end
    end
    if(k>=5)
        fig=3+lencsv;
        figure(fig)
        fils=2;cols=2;
        if(k==5)
            subplot(fils,cols,3)
        end
        if(k==6)
            subplot(fils,cols,4)
        end
    end

%     figure(k+lencsv)
%     subplot(2,1,1)
    h2 = boxplot(RESIDFM{k},SUBJECTS{k}','colors',COLORS{k},'symbol','o');
    set(h2(~isnan(h2)),'LineWidth',2)
    hold on
    boxplot(RESIDFM{k},SUBJECTS{k}','colors','k','symbol','ko')
    grid on
    xlabel('Sujetos')
    ylabel('Residuos')
    title(['{\bf Con efectos específicos - Parto #}',num2str(k)]);
    
%     xlabel('Subjects')
%     ylabel('Residuals')
%     title(['{\bf With Subject Specific Effects - Birth #}',num2str(k)]);
    
    set(gca,'Color',[0.85 0.85 0.85]);
    
end

%=====================================================
% GRAFICAS GRANDES - FITS AGRUPADAS
% ..........................................
% FIT UNICAS DE SUPERVACA CON
% FIT PERSONALIZADAS PARA CADA VACA
%=====================================================

for k=1:lencsv  
            
    if(k==1)
        fig=1;
        figure(fig)
        fils=2;cols=2;
        subplot(fils,cols,[3,4])
    end
    if(k>1) && (k<5)
        fig=2;
        figure(fig)
        fils=3;cols=4;
        if(k==2)
            subplot(fils,cols,[3,4])
        end
        if(k==3)
            subplot(fils,cols,[7,8])
        end
        if(k==4)
            subplot(fils,cols,[11,12])
        end
    end
    if(k>=5)
        fig=3;
        figure(fig);
        fils=2;cols=4;
        if(k==5)
            subplot(fils,cols,[3,4])
        end
        if(k==6)
            subplot(fils,cols,[7,8])
        end
    end
    
    gscatter(MET{k},MESY{k},SUBJECTS{k},COLORS(k));
    xlabel('Tiempo (días)');
    ylabel('Producción de leche (kg/día)');
    title(['{\bf Producción neta "Super Vaca" - Parto #}',num2str(k)]);
    
%     xlabel('Time (days)');
%     ylabel('Milk Production (kg/day)');
%     title(['{\bf Milk Yield SuperCow Birth #}',num2str(k)]);
    
    grid on
    hold on
    extraleg=[""];
    plot(TDASHED{k},model(PHIFS{k},TDASHED{k}),':',...
        'color',[.5 .5 .5],'LineWidth',3.5) ;
    hold on
    for I = 1:length(SUBS{k})
        plot(TDASHED{k},model(PHIFM{k}(:,I),TDASHED{k}),...
            'Color',COLORS{k}(I));
        extraleg(I)=strcat("Ajuste de ",SUBS{k}(I));
%         extraleg(I)=strcat(SUBS{k}(I),"'s Fit");
    end
    extraleg=['Ajuste único',extraleg];
%     extraleg=['Single Fit',extraleg];
    legend([SUBS{k},extraleg]);
    legend('Location','best','Orientation','horizontal');
    lgd = legend;
    lgd.NumColumns = 2;    
    
    set(gca,'Color',[0.85 0.85 0.85]);
end

%==============================================
% Aqui acaba de plotearse los primeros fit multiples
% ........................................
%==============================================


% % model = @(vphi,vt)...
% %     ((vphi(1)*(vt.^vphi(2))).*(exp(-1*vt*vphi(3))));

% === Modelo de Wood para todas las vacas de todos los partos =====
nlme_model = @(MPHI,vt)...
    ((MPHI(:,1)*(vt.^MPHI(:,2))).*(exp(-1*vt*MPHI(:,3))));

% %==========================================================================
% %==========================================================================
% %==========================================================================
% 
% % ===============   ANALISIS DE MATRICES DE COVAR   ======================
% % ==================   PARA PATRONES   ====================================
% % ================   se puede omitir para velocidad   =====================
% 
% %==========================================================================
% %==========================================================================
% %==========================================================================
% 
% % =================================================================
% %    PHINLME{k}= 3 Parametros para cada VACA de cada PARTO
% %    PSINLME{k}= PSI, mATRIZ DE COVARIANZA
% %    STATSNLME{k}= Stadistica del modelo NLME
% % =================================================================
% PHINLME={{}}; 
% PSINLME={{}}; 
% STATSNLME={{}}; 
% for k=1:lencsv
%     
%     [phinlme,PSInlme,statsnlme] = nlmefit(MET{k}, MESY{k},...
%         SUBJECTS{k},[],nlme_model,PHI0s{k});
%     PHINLME{k}=phinlme;
%     PSINLME{k}=PSInlme;
%     STATSNLME{k}=statsnlme;         
% end
% 
% % ===============================================
% % PHINLME - Phi para el ajuste con mixed non linear fit
% %.........................
% % ================================================
% 
% 
% %=========================================
% %===== COMPARE PHIFS CON PHINLME  ========
% %=========================================
% D=horzcat(PHIFS{1}',PHIFS{2}',PHIFS{3}',PHIFS{4}',PHIFS{5}',PHIFS{6}');
% C=horzcat(PHINLME{1},PHINLME{2},PHINLME{3},PHINLME{4},PHINLME{5},PHINLME{6});
% E=horzcat(C,D);
% % E es una matriz donde las primeras 6 columnas
% % son los params del fit unico, y las otras 6 columnas
% % son los params del fit personalizado a cada vaca
% %=========================================
% %===== COMPARE PSINLME  ========
% %=========================================
% F=horzcat(PSINLME{1},PSINLME{2},PSINLME{3},PSINLME{4},PSINLME{5},PSINLME{6});
% % OBSERVACIONES:  
% %     En La primera se pueden omitir parametros 2 y solo usar 1 y 3
% %     En la ultima, se puede omitir el parametro 1 y solo usar 2 y 3
% 
% %==============================================
% % Aqui vamos a hacer el nl me fit  pero
% % modificando esas matrices de valores que no estan
% % correlacionadas entre sí.
% % para eso hacemos el REparam Select
% % ........................................
% %==============================================
% %
% 
% %==========================================================================
% %==========================================================================
% %==========================================================================

PHINLME2={{}}; 
PSINLME2={{}}; 
STATSNLME2={{}}; 
for k=1:lencsv
    if(k==1)
        [phinlme2,PSInlme2,statsnlme2] = nlmefit(MET{k}, MESY{k},...
        SUBJECTS{k},[],nlme_model,PHI0s{k},...
        'REParamsSelect',[1 3]);
    elseif(k==6)
        [phinlme2,PSInlme2,statsnlme2] = nlmefit(MET{k}, MESY{k},...
        SUBJECTS{k},[],nlme_model,PHI0s{k},...
        'REParamsSelect',[2 3]);
    else
        [phinlme2,PSInlme2,statsnlme2] = nlmefit(MET{k}, MESY{k},...
        SUBJECTS{k},[],nlme_model,PHI0s{k});
    end
%     
%     [phinlme2,PSInlme2,statsnlme2] = nlmefit(MET{k}, MESY{k},...
%         SUBJECTS{k},[],nlme_model,PHI0s{k});
    PHINLME2{k}=phinlme2;
    PSINLME2{k}=PSInlme2;
    STATSNLME2{k}=statsnlme2;         
end
%  FOR THE FIRST PSINLME{1}..........
%  The Akaike information criterion "aic" is reduced from 3.924319
%   to 3.922319, and the Bayesian information criterion "bic"
%  is reduced from 3.91800937 to 3.9169107. 
%  These measures support the decision to drop the second random effect.
%  ===   mse  y  rmse tambien disminuyen (poquito pero lo hacen) ====
% 
%  FOR THE SIXTH PSINLME{6}..........
%  the Akaike information criterion "aic" is reduced from 1.435494037
%   to 1.433494037, and the Bayesian information criterion "bic"
%  is reduced from 1.426346067 to 1.425652920.  
%  These measures support the decision to drop the first random effect.
%  ===   mse  y  rmse tambien disminuyen (poquito pero o hacen)   ====


%======================================================
%======================================================
% ¿¿¿¿deberia usar short format y skippear parametros en el caso 2 3 4 y 5???
%======================================================
%======================================================



%======================================================
%=========   REFITTING WITH COVARIANCE MATRIX   =======
%======================================================
% Refitting the simplified model with a full covariance matrix allows
% for identification of correlations among the random effects.

%     To do this, use the CovPattern parameter to specify the pattern 
%     of nonzero elements in the covariance matrix.

%==============================================
% PHINLME2 RF -PHI con NLME 2- pues los random effects 
% que no estaban correlacionados se pueden omitir
% y luego les vamos a hacer un refit
% ........................................
%==============================================
PHINLME2RF={{}}; 
PSINLME2RF={{}}; 
STATSNLME2RF={{}}; 
for k=1:lencsv
    if(k==1)
        [phinlme2rf,PSInlme2rf,statsnlme2rf] = nlmefit(MET{k}, MESY{k},...
        SUBJECTS{k},[],nlme_model,PHI0s{k},...
        'REParamsSelect',[1 3],...
        'CovPattern',ones(2));
    elseif(k==6)
        [phinlme2rf,PSInlme2rf,statsnlme2rf] = nlmefit(MET{k}, MESY{k},...
        SUBJECTS{k},[],nlme_model,PHI0s{k},...
        'REParamsSelect',[2 3],...
        'CovPattern',ones(2));
    else
        [phinlme2rf,PSInlme2rf,statsnlme2rf] = nlmefit(MET{k}, MESY{k},...
        SUBJECTS{k},[],nlme_model,PHI0s{k},...
        'CovPattern',ones(3));
    end
%     
%     [phinlme2,PSInlme2,statsnlme2] = nlmefit(MET{k}, MESY{k},...
%         SUBJECTS{k},[],nlme_model,PHI0s{k});
    PHINLME2RF{k}=phinlme2rf;
    PSINLME2RF{k}=PSInlme2rf;
    STATSNLME2RF{k}=statsnlme2rf;         
end

% clf; 

%==============================================
% Figura de las matrices de random effects
figure() % 
% ........................................
%==============================================
fils=2;
cols=3;
RHO={{}};
RHO{1}=corrcov(PSINLME2RF{1});
RHO{2}=corrcov(PSINLME2RF{2});
RHO{3}=corrcov(PSINLME2RF{3});
RHO{4}=corrcov(PSINLME2RF{4});
RHO{5}=corrcov(PSINLME2RF{5});
RHO{6}=corrcov(PSINLME2RF{6});
for k=1:lencsv
    subplot(2,3,k)
    imagesc(RHO{k})
     % poner if para las mtrices  y saber si elimine la primero o segunda
     % columna
    set(gca,'XTick',[1 2 3],'YTick',[1 2 3])
%     title(['{\bf Random Effect Correlation for YIELD #}',num2str(k)])
    title(['{\bf Correlación por efectos aleatorios para Producción #}',num2str(k)])
    h3 = colorbar;
    set(get(h3,'YLabel'),'String','Correlación');  
%     set(get(h3,'YLabel'),'String','Correlation');  
end

%=============================
%  COVPAT{1}=[1 1;1 1];
% COVPAT{2}=[1 0 0;0 1 1;0 1 1];
% COVPAT{2}=[1 -1 -1;-1 1 1;-1 1 1];
% COVPAT{3}=[1 -1 -1;-1 1 1;-1 1 1];
% COVPAT{4}=[1 -1 0;-1 1 1;0 1 1];
% COVPAT{5}=[1 0 -1;0 1 0;-1 0 1];
% COVPAT{6}=[1 1;1 1];

% COVPAT{1}=[1 1;1 1];
% COVPAT{2}=[1 0 0;0 1 1;0 1 1];
% COVPAT{2}=[1 0 0;0 1 1;0 1 1];
% COVPAT{3}=[1 0 0;0 1 1;0 1 1];
% COVPAT{4}=[1 0 0;0 1 1;0 1 1];
% COVPAT{5}=[1 0 0;0 1 0;0 0 1];
% COVPAT{6}=[1 1;1 1];
%=========== ACOMODAMOS EL MODELO PARA EL PATRON DE LAS MATRICES COVPAT
COVPAT={{}};
% COVPAT{1}=[1 1;1 1];
% COVPAT{2}=[1 0 0;0 1 1;0 1 1];
% COVPAT{2}=[1 -1 -1;-1 1 1;-1 1 1];
% COVPAT{3}=[1 -1 -1;-1 1 1;-1 1 1];
% COVPAT{4}=[1 -1 0;-1 1 1;0 1 1];
% COVPAT{5}=[1 0 -1;0 1 0;-1 0 1];
% COVPAT{6}=[1 1;1 1];
COVPAT{1}=[1 1;1 1];
COVPAT{2}=[1 0 0;0 1 1;0 1 1];
COVPAT{2}=[1 0 0;0 1 1;0 1 1];
COVPAT{3}=[1 0 0;0 1 1;0 1 1];
COVPAT{4}=[1 0 0;0 1 1;0 1 1];
COVPAT{5}=[1 0 0;0 1 0;0 0 1];
COVPAT{6}=[1 1;1 1];

%==============================================
% PHINLME2RFPAT, Params de nlme con los patrones
% identificados visualmente en los random effects
% ........................................
%==============================================
PHINLME2RFPAT = {{}}; 
PSINLME2RFPAT = {{}}; 
STATSNLME2RFPAT = {{}}; 
BPAT = {{}}; 
for k=1:lencsv
    if(k==1)
        [phinlme2rfpat,PSInlme2rfpat,statsnlme2rfpat,bpat] = nlmefit(MET{k}, MESY{k},...
        SUBJECTS{k},[],nlme_model,PHI0s{k},...
        'REParamsSelect',[1 3],...
        'CovPattern',COVPAT{k});
    elseif(k==6)
        [phinlme2rfpat,PSInlme2rfpat,statsnlme2rfpat,bpat] = nlmefit(MET{k}, MESY{k},...
        SUBJECTS{k},[],nlme_model,PHI0s{k},...
        'REParamsSelect',[2 3],...
        'CovPattern',COVPAT{k});
    else
        [phinlme2rfpat,PSInlme2rfpat,statsnlme2rfpat,bpat] = nlmefit(MET{k}, MESY{k},...
        SUBJECTS{k},[],nlme_model,PHI0s{k},...
        'CovPattern',COVPAT{k});
    end
%     
%     [phinlme2,PSInlme2,statsnlme2] = nlmefit(MET{k}, MESY{k},...
%         SUBJECTS{k},[],nlme_model,PHI0s{k});
    PHINLME2RFPAT{k}=phinlme2rfpat;
    PSINLME2RFPAT{k}=PSInlme2rfpat;
    STATSNLME2RFPAT{k}=statsnlme2rfpat;         
    BPAT{k}=bpat;
end

%  FOR THE FIRST PSINLME{1}..........
%  The Akaike information criterion "aic" is reduced from 3.924319e+03
%   to 3.922319+03, AND THEN FROM 3.922319+03 TO 3.921065+03
%  and the Bayesian information criterion "bic" is reduced from
%  3.91800937 to 3.9169107. AND THEN FROM 3.9169107+03 TO 3.914755+03

 
%  FOR THE SIXTH PSINLME{6}..........
%  the Akaike information criterion "aic" is reduced from 1.435494037e+03
%   to 1.433494037e+03, AND THEN FROM 1.433494037e+03 TO 1.435252e+03
%  and the Bayesian information criterion "bic" is reduced from 
%  1.426346067e+03 to 1.425652920e+03.  AND THEN FROM 1.425652920e+03 TO 1.426104


%  The output b gives predictions of the three random effects
%  for each of the numvac-subjects. These are combined with the estimates
%  of the fixed effects in phi to produce the mixed-effects model.

%==============================================
% Vamos a sumar los parametros "estocastizados"
% con los parametros que dieron en el nlme2rf
% y los vamos a sumar, para obtener los 
% params finales si o si full hd
% BPAT{1} POR EJ, se le quito la primer fila, entonces
% solo se sumaran la 2da y 3er fila, pues en la primera
% los random effects no aportaban nada a la 
% optimización del ajuste. Esto se hace sumando zeros 
% en la primer fila
% ........................................
%==============================================

PHIMEFIN = {{}};
PSIMEFIN = PSINLME2RFPAT; 
STATSMEFIN = STATSNLME2RFPAT;
% BMEFIN = {{}}; % Es el mismo BPAT
% disp(['=================  MSE  ==============================='])
% disp(['===   A-L.M.    A-ME.Fijo   A-ME.Aleatorio    ========'])
%     disp(['=====  MSE Yield Birth #',num2str(j),' ====='])
% disp('     (3-pars)    (3*#v)-pars    (3*#v)-pars')
for k=1:lencsv
    if(k==1)
        PHIMEFIN{k} = repmat(PHINLME2RFPAT{k},1,length(SUBS{k})) +...
        [BPAT{k}(1,:);BPAT{k}(2,:);zeros(1,length(SUBS{k}))];
    elseif(k==6)
        PHIMEFIN{k} = repmat(PHINLME2RFPAT{k},1,length(SUBS{k})) +...
        [BPAT{k}(1,:);BPAT{k}(2,:);zeros(1,length(SUBS{k}))];
    else
        PHIMEFIN{k} = repmat(PHINLME2RFPAT{k},1,length(SUBS{k})) +...
        [BPAT{k}(1,:);BPAT{k}(2,:);BPAT{k}(3,:)];
    end
%        
%     NUMPARAMS(k) = numel(PHIMEFIN{k});
%     NUMOBS(k)=length(MET{k});
%     DF(k) = NUMOBS(k) - NUMPARAMS(k);
%     ESCAL(k)=(RESMEFIN{k}(:)'*RESMEFIN{k}(:));
%     MSEMEFIN(k) = ESCAL(k)/DF(k);
%     spc = ' ';
%     nspc1 = 6;
%     nspc2 = 5;
%     nspc3 = 8;
%     numdec = 4;
%     disp(['=====  Parto #',num2str(k),' ====='])
%     if(mses(k)<10)
%         nspc2 = 6;
%     end
%     if (MSEM(k)<10)
%         nspc3 = 9;
%     end
%     disp([join(repmat(spc,1,nspc1),''),...
%         num2str(round(mses(k),numdec)),...
%         join(repmat(spc,1,nspc2),''),...
%         num2str(round(MSEM(k),numdec)),...
%         join(repmat(spc,1,nspc3),''),...
%         num2str(round(MSEMEFIN(k),numdec)),...
%         '   ===== Parto #',num2str(k),' ====='])
end
PHIMEFIN;
PSIMEFIN;
STATSMEFIN;

RESMEFIN=RESIDFM;

%==============================================
%       AQUI YA HEMOS ACABADO EL FIT
%            POR MIXED EFFECTS
% ........................................
%==============================================

%==============================================
%       Ahora vamos a comparar los Stats 
%            de los ajustes de 
%             "nlin_S", "nlin_M", y "nlmefit" 
% .............................................
%     disp(['=====  MSE Yield Birth #',num2str(j),' ====='])
% disp('     (3-pars)    (3*#v)-pars    (3*#v)-pars')
%==============================================
% loglpar = 0;
% msepar = 0;
% rmsepar = 0;
% aicpar = 0;
% bicpar = 0;
disp(['                                                               '])
disp(['                                                               '])
disp(['==============================================================='])
disp(['=================  STATS  ====================================='])
disp(['==============================================================='])
disp(['                                                               '])
disp(['==============================================================='])
disp(['============  MSE  ============================================'])
disp(['==============================================================='])
disp(['===   A-L.M.    A-ME.Fijo   A-ME.Aleatorio    ========'])
for k=1:lencsv
    spc = ' ';
    nspc1 = 6;
    nspc2 = 5;
    nspc3 = 8;
    numdec = 4;
%     disp(['=====  Parto #',num2str(k),' ====='])
    if(mses(k)<10)
        nspc2 = 6;
    end
    if (STATSNLME2{k}.mse<10)
        nspc3 = 9;
    end
    disp([join(repmat(spc,1,nspc1),''),...
    num2str(round(mses(k),numdec)),...
    join(repmat(spc,1,nspc2),''),...
    num2str(round(STATSNLME2{k}.mse,numdec)),...
    join(repmat(spc,1,nspc3),''),...
    num2str(round(STATSMEFIN{k}.mse,numdec)),...
    '   ===== Parto #',num2str(k),' ====='])
end
disp(['                                                               '])
disp(['==============================================================='])
disp(['============  RMSE  ==========================================='])
disp(['==============================================================='])
disp(['===   A-L.M.    A-ME.Fijo   A-ME.Aleatorio    ========'])
for k=1:lencsv
    spc = ' ';
    nspc1 = 6;
    nspc2 = 5;
    nspc3 = 8;
    numdec = 4;
%     disp(['=====  Parto #',num2str(k),' ====='])
    if(mses(k)^(0.5)<10)
        nspc2 = 6;
    end
    if ((STATSNLME2{k}.mse)^(0.5)<10)
        nspc3 = 9;
    end
    disp([join(repmat(spc,1,nspc1),''),...
    num2str(round((mses(k))^(0.5),numdec)),...
    join(repmat(spc,1,nspc2),''),...
    num2str(round((STATSNLME2{k}.mse)^(0.5),numdec)),...
    join(repmat(spc,1,nspc3),''),...
    num2str(round((STATSMEFIN{k}.mse)^(0.5),numdec)),...
    '   ===== Parto #',num2str(k),' ====='])
end
disp(['                                                               '])
disp(['==============================================================='])
disp(['============  Log-Likelyhood  ================================='])
disp(['==============================================================='])
disp(['===   A-ME.Fijo       A-ME.Aleatorio    ========'])
for k=1:lencsv
    spc = ' ';
%     nspc1 = 6;
    nspc2 = 5;
    nspc3 = 8;
    numdec = 4;
% %     disp(['=====  Parto #',num2str(k),' ====='])
%     if(mses(k)<10)
%         nspc2 = 6;
%     end
%     if (STATSNLME{k}.logl<10)
%         nspc3 = 9;
%     end
    disp([join(repmat(spc,1,nspc2),''),...
    num2str(round(STATSNLME2{k}.logl,numdec)),...
    join(repmat(spc,1,nspc3),''),...
    num2str(round(STATSMEFIN{k}.logl,numdec)),...
    '   ===== Parto #',num2str(k),' ====='])
end
disp(['                                                               '])
disp(['==============================================================='])
disp(['============  AIC  ============================================'])
disp(['==============================================================='])
disp(['===   A-ME.Fijo       A-ME.Aleatorio    ========'])
for k=1:lencsv
    spc = ' ';
    nspc1 = 6;
    nspc2 = 5;
    nspc3 = 8;
    numdec = 4;
% %     disp(['=====  Parto #',num2str(k),' ====='])
%     if(mses(k)<10)
%         nspc2 = 6;
%     end
%     if ((k)<10)
%         nspc3 = 9;
%     end
    disp([join(repmat(spc,1,nspc2),''),...
    num2str(round(STATSNLME2{k}.aic,numdec)),...
    join(repmat(spc,1,nspc3),''),...
    num2str(round(STATSMEFIN{k}.aic,numdec)),...
    '   ===== Parto #',num2str(k),' ====='])
end
disp(['                                                               '])
disp(['==============================================================='])
disp(['============  BIC  ============================================'])
disp(['==============================================================='])
disp(['===   A-ME.Fijo       A-ME.Aleatorio    ========'])
for k=1:lencsv
    spc = ' ';
    nspc1 = 6;
    nspc2 = 5;
    nspc3 = 8;
    numdec = 4;
% %     disp(['=====  Parto #',num2str(k),' ====='])
%     if(mses(k)<10)
%         nspc2 = 6;
%     end
%     if ((k)<10)
%         nspc3 = 9;
%     end
    disp([join(repmat(spc,1,nspc2),''),...
    num2str(round(STATSNLME2{k}.bic,numdec)),...
    join(repmat(spc,1,nspc3),''),...
    num2str(round(STATSMEFIN{k}.bic,numdec)),...
    '   ===== Parto #',num2str(k),' ====='])
end
disp(['==============================================================='])
disp(['==============================================================='])
disp(['                                                               '])

%==============================================
% Ploteos de los Mixed Effects por parto
% y de forma individual comparada con nlinfit
% ........................................
%==============================================

for k=1:lencsv
    if(k==1)
        fig=k+(3*lencsv);
        figure(fig)
        fils=1;cols=3;
    end
    if(k>1) && (k<5)
        fils=2;cols=4;
        fig=k+(3*lencsv);
        figure(fig)
    end
    if(k>=5)
        fig=k+(3*lencsv);
        figure(fig)
        fils=1;cols=2;
    end
    for I = 1:length(SUBS{k})
        tI = T{k};
        yI = SVY{k}{I};
        aux333=fitmodme(PHIMEFIN,tI,k,I);
        RESMEFIN{k}(:,I) = yI - aux333;
        subplot(fils,cols,I)
        scatter(tI,yI,5,COLORS{k}(I),'filled') % 10 es que tan grandes los ptos del scatter
        hold on
%       ==============================================
%        Hacemos comparativa de los super fit con el single
%       ==============================================
        plot(TDASHED{k},fitmodme(PHIMEFIN,TDASHED{k},k,I),'Color',COLORS{k}(I))
        plot(TDASHED{k},model(PHIFS{k},TDASHED{k}),':',...
        'color',[.5 .5 .5],'LineWidth',3.5) 
%             axis([0 8 0 3.5])
        xlabel('Tiempo (días)');
        ylabel('Producción de leche (kg/día)');
%         xlabel('Time (days)');
%         ylabel('Milk Production (kg/day)');
        
%             extraleg=['Single Fit',extraleg];
%             legend([SUBS{k},extraleg]);
        legend(SUBS{k}(I),strcat("Ajuste ME de ",SUBS{k}(I)),'Ajuste único')
%         legend(SUBS{k}(I),strcat(SUBS{k}(I),"'s ME Fit"),'Single Fit')
        set(gca,'Color',[0.85 0.85 0.85]);
    end

end





%==============================================
% Ploteos de los Mixed Effects 
% agrupados con nlinfit
% ........................................
%==============================================
fils=1;cols=1;
for k=1:lencsv
    if(k==1)
        fig=k+(4*lencsv);
        figure(fig)        
    end
    if(k>1) && (k<5)
        fig=k+(4*lencsv);
        figure(fig)
    end
    if(k>=5)
        fig=k+(4*lencsv);
        figure(fig)
    end
    extralegnorm=[""];
    grid on
%     plot(TDASHED{k},model(PHIFS{k},TDASHED{k}),':',...
%         'color',[.5 .5 .5],'LineWidth',3.5) 
%     hold on
    for I = 1:length(SUBS{k})
        tI = T{k};
        yI = SVY{k}{I};
        aux333=fitmodme(PHIMEFIN,tI,k,I);
        RESMEFIN{k}(:,I) = yI - aux333;
        subplot(fils,cols,1)
        % El 3er parametro es el tamaño de los ptos del scatter
        scatter(tI,yI,10,COLORS{k}(I),'filled') 
        hold on
%       ==============================================
%         Ploteamos el NLMEFIT individual de color
%         plot(TDASHED{k},fitmodme(PHIMEFIN,TDASHED{k},k,I),'Color',COLORS{k}(I))
%       ==============================================
        extralegnorm(I) = SUBS{k}(I);
%         legend([SUBS{k}(I),extraleg(I)])%,'Single Fit')
%         legend(SUBS{k}(I))%,extraleg(I))%,'Single Fit')
%         set(gca,'Color',[0.85 0.85 0.85]);
    end
    
%     extraleg=[""];
    extraleg=extralegnorm(:);
    extralegmefit=[""];
    for I = 1:length(SUBS{k})
%         tI = T{k};
%         yI = SVY{k}{I};
%         aux333=fitmodme(PHIMEFIN,tI,k,I);
%         RESMEFIN{k}(:,I) = yI - aux333;
        subplot(fils,cols,1)
        hold on
%       ==============================================
%         Ploteamos el NLMEFIT individual de color
        plot(TDASHED{k},fitmodme(PHIMEFIN,TDASHED{k},k,I),'Color',COLORS{k}(I))
%       ==============================================
        extralegmefit(I)=strcat("Ajuste ME de ",SUBS{k}(I));
%         extralegmefit(I)=strcat(SUBS{k}(I),"'s ME Fit");
%         legend([SUBS{k}(I),extraleg(I)])%,'Single Fit')
%         legend(SUBS{k}(I))%,extraleg(I))%,'Single Fit')
%         set(gca,'Color',[0.85 0.85 0.85]);
    end
%     extralegaux=[""];
    extralegaux=extralegmefit(:);
    extralegfin=vertcat(extraleg, extralegaux);
    plot(TDASHED{k},model(PHIFS{k},TDASHED{k}),':',...
        'color',[.5 .5 .5],'LineWidth',3.5) 
    hold on
    extralegfin=(vertcat(extralegfin,'Ajuste único')');
%     extralegfin=(vertcat(extralegfin,'Single Fit')');
    xlabel('Tiempo (días)');
    ylabel('Producción de leche (kg/día)');
    title(['{\bf Producción neta "Super Vaca" - Parto #}',num2str(k)]);
    
%     xlabel('Time (days)');
%     ylabel('Milk Production (kg/day)');
%     title(['{\bf Milk Yield SuperCow Birth #}',num2str(k)]);
    
    legend(extralegfin);
    legend('Location','best','Orientation','horizontal');
    lgd = legend;
    lgd.NumColumns = 2; 
    
    set(gca,'Color',[0.85 0.85 0.85]);

end
%==============================================
% Ploteos de las distribuciones 
% de probabilidad
% ........................................
%==============================================

for k=1:lencsv
    if(k==1)
        fig=1+(5*lencsv);
        figure(fig)
        fils=2;
        cols=1;
        subplot(fils,cols,1)
    end
    if(k>1) && (k<5)
        fig=2+(5*lencsv);
        figure(fig)
        fils=2;cols=3;
        if(k==2)
            subplot(fils,cols,1)
        end
        if(k==3)
            subplot(fils,cols,2)
        end
        if(k==4)
            subplot(fils,cols,3)
        end
    end
    if(k>=5)
        fig=3+(5*lencsv);
        figure(fig)
        fils=2;cols=2;
        if(k==5)
            subplot(fils,cols,1)
        end
        if(k==6)
            subplot(fils,cols,2)
        end
    end
    normplot(RESMEFIN{k}(:))
    title(['{\bf Ploteo de probabilidad normal - con datos atípicos } - Producción #',num2str(k)]);
    xlabel('Datos');
    ylabel('Probabilidad');
%     title(['{\bf Normal Probability Plot ...- With Outliers} - Yield #',num2str(k)]);
% % %     title(['{\bf Random Effect Correlation for YIELD #}',num2str(k)])
end


% %     PHI2=reshape(PHI2,[],1)
% %     p_true=phi011';
% %     % global p_true_lm
% %     p_true_lm = [7.7578 0.1021 0.0026 7.1934 0.1322 0.0025 8.5642 0.1872 0.0038]'; %Del lm_examtes3graf
% %     p_true_lm_script=(p_true_lm)
% %     % sigma_p=;
% %     disp('=======================  Sol  ==========================')
% %     disp('     true     3x3fit    LM-Fit    NlmeFit')
% %     disp('========================================================')
% %     % disp ([  p_true  PHI2  p_true_lm_script 100*abs(PHI2-p_true_lm_script)./p_true ])
% %     disp ([  p_true  PHI2  p_true_lm_script phi11' ])
% % 

