function [splyres]=SplCubLFGG(t,y,nsamples)
% t = Muestras del eje horizontal (vector o linspace)
% t = [1 2 3 4 5 6 7 8 9 10 11];
% Valores Eje Vertical, si son funciones pues escribimos la funcion
% y = 1./(1+(25.*(t.^2)));
% y= [444 444 444 503 435 511 472 483 553 560 620]

%n = Number of points that will be interpolated
n=length(t);
% First value of interval [a,b]
a=t(1);
% Last value of interval [a,b]
b=t(n);

% step=0.01;
% tcont = (a):step:(b); % Tiempo "continuo"
tcont = linspace(a,b,nsamples);

% yideal= [444,444.246198285875,444.490837762798,444.732359621818,444.969205053981,445.199815250336,445.422631401932,445.636094699816,445.838646335035,446.028727498639,446.204779381676,446.365243175192,446.508560070237,446.633171257858,446.737517929103,446.820041275021,446.879182486659,446.913382755065,446.921083271288,446.900725226375,446.850749811375,446.769598217335,446.655711635304,446.507531256329,446.323498271458,446.102053871740,445.841639248223,445.540695591955,445.197664093983,444.810985945355,444.379102337121,443.900464922996,443.376165098856,442.813206888905,442.219384401399,441.602491744598,440.970323026758,440.330672356137,439.691333840994,439.060101589585,438.444769710169,437.853132311004,437.292983500346,436.772117386455,436.298328077587,435.879409682000,435.523156307952,435.237362063702,435.029821057505,434.908327397621,434.880675192307,434.954658549821,435.138071578420,435.438708386363,435.864363081906,436.422829773309,437.121902568828,437.969375576721,438.973042905246,440.140698662660,441.480136957223,442.999151897190,444.705264002419,446.595506282199,448.653293182932,450.861122849144,453.201493425359,455.656903056102,458.209849885899,460.842832059275,463.538347720756,466.278895014867,469.046972086132,471.825077079077,474.595708138227,477.341363408109,480.044541033245,482.687739158163,485.253455927387,487.724189485443,490.082437976855,492.310699546150,494.391472337851,496.307254496486,498.040544166577,499.573839492652,500.889638619235,501.970439690851,502.798740852026,503.357040247285,503.627836021153,503.593626318155,503.236909282817,502.541661207317,501.514245801665,500.178249173712,498.557689265774,496.676584020164,494.558951379199,492.228809285194,489.710175680462,487.027068507321,484.203505708084,481.263505225066,478.231085000584,475.130262976951,471.985057096483,468.819485301495,465.657565534302,462.523315737219,459.440753852561,456.433897822644,453.526765589782,450.743375096291,448.107744284485,445.643891096679,443.375833475189,441.327589362330,439.523176700417,437.986613431765,436.741917498688,435.813106843503,435.224199408523,434.999213136065,435.158168350215,435.691469817469,436.576258452292,437.789614518165,439.308618278572,441.110349996996,443.171889936919,445.470318361824,447.982715535194,450.686161720511,453.557737181258,456.574522180919,459.713596982975,462.952041850910,466.266937048206,469.635362838346,473.034399484813,476.441127251089,479.832626400658,483.185977197001,486.478259903603,489.686554783945,492.787942101510,495.759502119781,498.578315102241,501.221461312373,503.666021013659,505.889074469582,507.867701943624,509.578983699269,511,512.114076974792,512.929443549916,513.460574517138,513.721944668222,513.728028794933,513.493301689035,513.032238142293,512.359312946471,511.489000893335,510.435776774649,509.214115382178,507.838491507686,506.323379942938,504.683255479698,502.932592909732,501.085867024804,499.157552616678,497.162124477120,495.114057397894,493.027826170764,490.917905587496,488.798770439853,486.684895519601,484.590755618504,482.530825528327,480.519580040835,478.571493947792,476.701042040963,474.922699112112,473.250939953005,471.700217557265,470.280581438959,468.992268251653,467.834181775413,466.805225790306,465.904304076399,465.130320413759,464.482178582452,463.958782362545,463.559035534105,463.281841877198,463.126105171892,463.090729198252,463.174617736346,463.376674566240,463.695803468002,464.130908221697,464.680892607393,465.344660405156,466.121115395054,467.009161357151,468.007702071517,469.115641318216,470.331882877317,471.655330528885,473.084888052987,474.619459229691,476.257947839062,477.999257661168,479.842292476075,481.785956063851,483.829075925490,485.967516568322,488.193293546883,490.498165085996,492.873889410486,495.312224745176,497.804929314891,500.343761344455,502.920479058692,505.526840682425,508.154604440479,510.795528557679,513.441371258847,516.083890768809,518.714845312387,521.325993114407,523.909092399692,526.455901393066,528.958178319354,531.407681403379,533.796168869965,536.115398943937,538.357129850119,540.513119813334,542.575127058408,544.534909810162,546.384226293423,548.114834733014,549.718493353758,551.186960380480,552.511994038005,553.685974359377,554.710573551784,555.594617463387,556.347116452713,556.977080878286,557.493521098632,557.905447472276,558.221870357744,558.451800113560,558.604247098252,558.688221670344,558.712734188361,558.686795010830,558.619414496275,558.519603003222,558.396370890196,558.258728515723,558.115686238329,557.976254416538,557.849443408877,557.744263573870,557.669725270044,557.634838855923,557.648614690033,557.720063130900,557.858194537048,558.072019267004,558.370547679294,558.762790132441,559.257756984972,559.864458595413,560.590796228714,561.436480516181,562.397550143130,563.470026304752,564.649930196237,565.933283012774,567.316105949555,568.794420201770,570.364246964609,572.021607433261,573.762522802919,575.583014268771,577.479103026007,579.446810269819,581.482157195397,583.581164997930,585.739854872609,587.954248014625,590.220365619167,592.534228881426,594.891858996592,597.289277159855,599.722504566406,602.187562411435,604.680471890132,607.197254197688,609.733930529292,612.286522080135,614.851050045407,617.423535620299,620];
% yideal= 1./(1+(25.*(tcont.^2)));
h=zeros(1,n-1); % We then must substract next values of t with the actual value of t (future-present)
dy=zeros(1,n-1); % We then must do the same for the function itself so that we can calculate derivatives
for i=1:n-1
    h(1,i)=t(i+1)-t(i);   
    dy(1,i)=y(i+1)-y(i);
end
% h
S=zeros(n-2,n+1); %This is a (n-2)x(n+1) Zero-Matrix to store equations of \phi_j(t) 
k=zeros(1,n-2);
acum=0;
for i=2:n-1
       k(i-1)=acum+i;
end
% k
for i=1:n-2
    for j=1:n+1
        if k(i)==j+1
            S(i,j)=h(k(i)-1);
        elseif k(i)==j
            S(i,j)=2*(h(k(i)-1)+h(k(i)));
        elseif k(i)==j-1
            S(i,j)=h(k(i));
        elseif j==n+1
            S(i,n+1)=(6*(((dy(k(i))))/((h(k(i))))-(((dy(k(i)-1))))/((h(k(i)-1)))));
        else    
            S(i,j)=0;
        end
    end
end
for i=1:n-2
    for j=1:n+1
        if j==1
           S(i,1)=0;
        else j==n
           S(i,n)=0;
        end
    end     
end
% S
Sol=rref(S); %Gauss Solutions of phi equiations
s=zeros(1,n);
for i=2:n-1
    for j=1:n+1
        if j==n+1
            s(1,i)=Sol(i-1,n+1);
        end
    end
end

%%%%%%%%%%%%% Example from mathworks forum%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% n      = 100;          % store 100 valores
% Result = zeros(3, n);  % reserve memory for n [1x3] vectors
% for k = 1:100
%     v = rand(1, 3);    % obtain the vector, your code comes here
%     
%     Result(:, k) = v;  % collect the vectors in a matrix
% end
% Creates a 3 rows 100 cols matrix
%%%%%%%%%%%%% Example from mathworks forum%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% In this example i only have 5 point so i will have 4 splines, but, for and n-dim ension splines y requiere more than just 4 splineq-equiations
splinesq=zeros(n-1,length(tcont)); % For n-points, (n-1)-splines will be required.
% splinesq;
for i=1:n-1 % We are comparing to a "continuos" function from a to b with a step of 0.01
    aux2= (s(i)/6)*( (((t(i+1)-tcont).^3)/h(i))-(h(i)*(t(i+1)-tcont)) )+(s(i+1)/6)*((((tcont-t(i)).^3)/h(i))-(h(i)*(tcont-t(i))))+(y(i))*((t(i+1)-tcont)/h(i))+(y(i+1))*((tcont-t(i))/h(i));
    splinesq(i,:)= aux2;
end
% splinesq;
f=zeros(1,length(tcont));
% superf=[];
for i=1:n-1
    if(i==n-1)
        aux=((tcont>=t(i))&(tcont<=t(i+1))).*(splinesq(i,:));
        f=f+aux;
    else
        aux=((tcont>=t(i))&(tcont<t(i+1))).*(splinesq(i,:));
        f=f+aux;
    end
end
splyres=f;
% ye=yideal-f;
% ye=abs(f-yideal);
end




% figure(1)
% subplot(211)
% plot(tcont,f,'r')
% % plot(tcont,superf,'r'),grid
% hold on
% plot(t,y,'o')
% hold on
% % plot(tcont,yideal,'b'),grid
% % legend('Spline','Puntos','Funcion y ideal')
% legend('Spline','Puntos')
% 
% subplot(212)
% semilogy(tcont,ye,'b'),grid
% legend('Error Spline vs Ideal function')

% figure(1)
% subplot(211)
% plot(tcont,f,'r')
% % plot(tcont,superf,'r'),grid
% hold on
% plot(t,y,'o')
% hold on
% % plot(tcont,yideal,'b'),grid
% % legend('Spline','Puntos','Funcion y ideal')
% legend('Spline','Puntos')
% 
% 
% subplot(212)
% semilogy(tcont,ye,'b'),grid
% legend('Error Spline vs Ideal function')
