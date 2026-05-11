close all
clear

%Define parameters as in the paper
sigma=0.4; %buyers' market power - OLD VALUE = 0.4
lambdaP=0.35; %absconding payoff from alternative platform lender
theta=4; %value that H-sellers produce if receiving extending loans - OLD VALUE = 4
uH=12; %H-buyers' utility from consuming High quality good
u=8; %H-buyers' utility from consuming Low quality goods and L-buyers from consuming goods
c1=0.1; %cost of transaction made in stablecoin
beta = 0.5;
eP=0;
%%Define range of transaction cost
tc = zeros(1,30);
for y = 1:30
    tc(y)= (y-1)/100;
end
tcL = zeros(1,30);
for i = 1:30
    tcL(i) = (i-1)/100;
end
tcH = zeros(1,30);
for j = 1:30
    tcH(j) = (j-1)/100;
end
%%Define value range of q - percentage of H-sellers
q = zeros(1,100); 
x1 = linspace(1,100,100);
for x=1:100
    q(x)=(x-1)/100; 
end
%%Define value range of lambda - absconding value of running from banks
l = zeros(1,100); 
for z=1:100
    l(z)=(z-1)/100; 
end



for z = 1:100
    for i = 1:30
        pH(z,i) = (1- sigma)*uH + sigma*l(z) - sigma*(theta-1);
    end
end
for z = 1:100
    for i =1:30
        rH_ST(z,i) = (1 - tcL(i))*(1-l(z))*((1 - sigma)*u + sigma*l(z)) + l(z)*theta;
    end
end
    Hpayoff_ST = pH - rH_ST-1;

%Condition above which sellers opts for online when banks offer partially
%pooling contract with the term including the term (e-q.lambda.theta)
for x=1:100
    Lam1(x)=(q(x).^2*((1-sigma)*(uH-u)-sigma*(theta-1)))/(-0.025*q(x)*theta + q(x)*((1-sigma)*(uH-u)-sigma*(theta-1)));       
end
%Condition above which banks offer separating contract including the term (e-q.lambda.theta)
for x=1:100
    Lam2(x)=1 - (q(x)*(1-q(x)))/sigma;       
end
%Condition above which sellers opts for online when banks offer separating contract including the term (e-q.lambda.theta)
for x=1:100
    Lam3(x)=(q(x).^2*(1-sigma)*(uH-u)+(1-q(x))*sigma*(theta - 1))/(q(x)*((1-sigma)*(uH-u)-sigma*(theta-1))-0.025*q(x)*theta+sigma*(theta-1));       
end

%Constant line to make it look like the paper AT lAMBDA = 0.75
for x=1:100
    con(x)=0.75;
end
%Constant line to make it look like the paper AT lAMBDA = 0.9
for x=1:100
    con09(x)=0.9;
end

%Constant line at lambda = 1
for x=1:100
    con1(x)=1;
end

%Constant line at lambda = 0
for x=1:100
    con0(x)=0;
end
%Limit value of Lambda
for x=1:100
    low_limit(x)=0;
    up_limit(x) = 1;
end
%The cost threshold under which sellers opts for stablecoin instead of cash
%when banks offer partially contract
for x=1:100
    CostP(x)=q(x)*(1-q(x))*((1-sigma)*(uH-u)-sigma*(theta-1));
end

% Old Lam9 Lam9(x,y)=(tc(y)+q(x)*(q(x)-1)*(1-sigma)*(uH-u)+(theta-1)*sigma)/(sigma*(theta-1));
%Condition above which sellers opts for CBDC instead of cash
%when banks offer separating contract
for x=1:100
    Lam10(x)=(q(x)*(q(x)-1)*(1-sigma)*(uH-u)+(theta-1)*sigma)/(sigma*(theta-1));
end



%Forging account cost when lambda = 0.5
for x =1:100
    e = 1.025*q(x)*theta*0.5;
end



% % % % % % %SOLVING FOR S_ONSTA > S_OND with incorporated transaction cost into bank
%profit
b1 = zeros(100,30,30);
b2 = zeros(100,30,30);
b3 = zeros(100,30,30);
b4 = zeros(100,30,30);
B = zeros(100,30,30);
c1 = zeros(100,30,30);
c2 = zeros(100,30,30);
C = zeros(100,30,30);
for x = 1:100
    for i = 1:30
        for j = 1:30
            b1(x,i,j) = tcL(i)*(1-sigma)*u;
            b2(x,i,j) = q(x)*((1-sigma)*(uH-u) - sigma*(theta-1));
            b3(x,i,j) = -sigma*q(x)*(tcL(i) - tcH(j));
            b4(x,i,j) = -0.025*q(x)*theta;
            B(x,i,j) = b1(x,i,j) + b2(x,i,j) + b3(x,i,j) + b4(x,i,j);
        end
    end
end
for x = 1:100
    for i = 1:30
        for j = 1:30
            c1(x,i,j) = (1 - sigma)*((1 - tcH(j))*uH - (1 - tcL(i))*u);
            c2(x,i,j) = - (1 - tcH(j))*sigma*(theta - 1);
            C(x,i,j) = -q(x)*(c1(x,i,j) + c2(x,i,j));
        end
    end
end

for x = 1:100
    for i = 1:30
        for j = 1:30
            A(x,i,j) = sigma*(tcL(i));
        end
    end
end
delta = zeros(100,30,30);
for x = 1:100
    for i = 1:30
        for j = 1:30
            delta(x,i,j) = B(x,i,j)^2 - 4*A(x,i,j)*C(x,i,j);
        end
    end
end

for x = 1:100
    for i = 1:30
        for j = 1:30
            root_STA_OND_1(x,i,j) = (-B(x,i,j) + sqrt(delta(x,i,j)))/(2*A(x,i,j));
%             root_lambda_2(x,i,j) =  (-B(x,i,j) - sqrt(delta(x,i,j)))/(2*A(x,i,j));
        end
    end
end

% % % % % % % % % %SOLVING FOR S_ONSTA > S_SEP_Cash % % % % % % % %
b2_1 = zeros(100,30,30);
b2_2 = zeros(100,30,30);
b2_3 = zeros(100,30,30);
b2_4 = zeros(100,30,30);
B2 = zeros(100,30,30);
c2_1 = zeros(100,30,30);
c2_2 = zeros(100,30,30);
c2_3 = zeros(100,30,30);
c2_4 = zeros(100,30,30);
C2 = zeros(100,30,30);

% kmin = 0;
% MaxK = 30;
% kmax = 100;
% for k=1:kmax
%     lu(k)=k*(MaxK/kmax);
% end
% k = linspace(kmin,kmax,20);
for x = 1:100
    for i = 1:30
        for j = 1:30
            b2_1(x,i,j) = tcL(i)*(1-sigma)*u;
            b2_2(x,i,j) = -q(x)*sigma*(tcL(i)-tcH(j));
            b2_3(x,i,j) = -sigma*(theta-1);
            B2(x,i,j) = b2_1(x,i,j) + b2_2(x,i,j) + b2_3(x,i,j);
        end
    end
end
for x = 1:100
    for i = 1:30
        for j = 1:30
            c2_1(x,i,j) = q(x)^2*(1-sigma)*(uH-u);
            c2_2(x,i,j) = (1-q(x))*sigma*(theta-1);
            c2_3(x,i,j) = -q(x)*(1-sigma)*((1-tcH(j))*uH - (1-tcL(i))*u);
            c2_4(x,i,j) = q(x)*(1-tcH(j))*sigma*(theta-1);
            C2(x,i,j) = c2_1(x,i,j) + c2_2(x,i,j) + c2_3(x,i,j) + c2_4(x,i,j);
        end
    end
end
A2 = zeros(100,30,30);
for x = 1:100
    for i = 1:30
        for j = 1:30
            A2(x,i,j) = sigma*(tcL(i));
        end
    end
end
delta2 = zeros(100,30,30);
for x = 1:100
    for i = 1:30
        for j = 1:30
            delta2(x,i,j) = B2(x,i,j)^2 - 4*A2(x,i,j)*C2(x,i,j);
        end
    end
end

for x = 1:100
    for i = 1:30
        for j = 1:30
            root_STA_SEP_2_1(x,i,j) = (-B2(x,i,j) + sqrt(delta2(x,i,j)))/(2*A2(x,i,j));
            root_STA_SEP_2_2(x,i,j) =  (-B2(x,i,j) - sqrt(delta2(x,i,j)))/(2*A2(x,i,j));
        end
    end
end

% % % % % Value of difference between STA and SEP
for x = 1:100
    for z = 1:100
        Difference_STA_SEP_5(x,z) = l(z)^2*A2(x,5,5) + l(z)*B(x,5,5)+C(x,5,5);
    end
end
Difference_STA_SEP_5(50,80)
Difference_STA_SEP_5(50,50)
for x = 1:100
    for z = 1:100
        Difference_STA_SEP_0(x,z) = l(z)^2*A2(x,1,1) + l(z)*B(x,1,1)+C(x,1,1);
    end
end
% % % % % % % % %  SOLVING FOR S_ONSTA > S_PARTPool_Cash % % % % % % % %
b3_1 = zeros(100,30,30);
b3_2 = zeros(100,30,30);
B3 = zeros(100,30,30);
c3_1 = zeros(100,30,30);
c3_2 = zeros(100,30,30);
c3_3 = zeros(100,30,30);
C3 = zeros(100,30,30);

for x = 1:100
    for i = 1:30
        for j = 1:30
            b3_1(x,i,j) = tcL(i)*(1-sigma)*u;
            b3_2(x,i,j) = -q(x)*sigma*(tcL(i) - tcH(j));
            B3(x,i,j) = b3_1(x,i,j)+ b3_2(x,i,j);
        end
    end
end

for x = 1:100
    for i = 1:30
        for j = 1:30
            c3_1(x,i,j) = q(x)*(1-sigma)*((1-tcH(j))*uH - (1-tcL(i))*u);
            c3_2(x,i,j) = -q(x)*(1-tcH(j))*sigma*(theta-1);
            c3_3(x,i,j) = -q(x)^2*((1-sigma)*(uH-u) - sigma*(theta - 1));
            C3(x,i,j) = -(c3_1(x,i,j)+ c3_2(x,i,j) + c3_3(x,i,j));
        end
    end
end

A3 = zeros(100,30,30);
for x = 1:100
    for i = 1:30
        for j = 1:30
            A3(x,i,j) = sigma*(tcL(i));
        end
    end
end
delta3 = zeros(100,30,30);
for x = 1:100
    for i = 1:30
        for j = 1:30
            delta3(x,i,j) = B3(x,i,j)^2 - 4*A3(x,i,j)*C3(x,i,j);
        end
    end
end

root_STA_PART_3_1 = zeros(100,6,6);
root_lambda_3_2 = zeros(100,6,6);
for x = 1:100
    for i = 1:6
        for j = 1:6
            root_STA_PART_3_1(x,i,j) = (-B3(x,i,j) + sqrt(delta3(x,i,j)))/(2*A3(x,i,j));
            root_STA_PART_3_2(x,i,j) =  (-B3(x,i,j) - sqrt(delta3(x,i,j)))/(2*A3(x,i,j));
        end
    end
end

% % % % % % % % % % % WHEN tcH = tcL = 0 % % % % % % % % % % % 
% for x = 1:100
%     Res_STA_OND(x) = -C(x,1,1)./B(x,1,1);
% end
    
    Res_STA_OND = -C./B;
    Res_STA_SEP = -C2./B2;
    Res_STA_PART = -C3./B3;
    
% for x = 1:100
%     Res_STA_SEP(x) = -C2(x,1,1)/B2(x,1,1);
% end
% for x = 1:100
%     Res_STA_PART(x) = -C3(x,1,1)/B3(x,1,1);
% end

% Condition to the right deposit is prefered rather than stablecoin when
% borrowing from platform
for i = 1:30
    for j = 1:30
        q_D_STA(i,j) = (-beta*lambdaP.^2*sigma*tcL(i) + eP + lambdaP*sigma*tcL(i)*u - lambdaP*tcL(i)*u)./(beta*lambdaP*sigma*tcH(j) - beta*lambdaP*sigma*tcL(i) - sigma*tcH(j)*theta - sigma*tcH(j)*uH + sigma*tcH(j) + sigma*tcL(i)*u + tcH(j)*uH - tcL(i)*u);
    end
end


% 
%The range in which sellers opts for stablecoin rather than cash when banks
%offer partial constract

%--------------------------------------------------------------------
%-------------DEPOSIT VS CASH----------------------------------------
figure
plot(Lam1(1:39),"b");
hold on
plot(Lam2(:),'r','LineWidth',2);
hold on
plot(Lam3(:),"b");
hold on
plot(con(:),'c');
text(35,0.74,'Deposit - Online', 'FontWeight','bold')
text(40,0.48,'Cash Offline')
text(40,0.43,'Sep. contract')
text(40,0.2,'Cash Offline')
text(40,0.15,'Partial contract')
text(4,0.4,'Deposit - Online', 'FontWeight','bold')
title('Cash vs Deposit payment','FontName','Times New Roman','FontSize',16)
xlabel('q - Probability of banking exploitation (percentage of H-sellers)')
ylabel('Adverse selection extent (\lambda - absconding payoff )')


%-------------------------------------------------------------------------
%-------------------------------------------------------------------------
%-------------------------------------------------------------------------
%------------- PARTIAL POOLING  CONTRACT AND SEPARATING CONTRACT----------
figure
subplot(1,2,1)
x = 29:1:95;
plot(x,root_STA_SEP_2_2(x,5,3), 'g');
hold on
x= 1:1:29;
plot(x, Lam3(x), 'b')
hold on
x=29:1:100;
plot(x,root_STA_OND_1(x,5,3), 'k');
hold on
plot(con09(:),'c');
text(30,0.8,'Deposit Online', 'FontWeight','bold')
text(35,0.7,'Stablecoin Online', 'FontWeight','bold')
text(40,0.6,'Cash Ofline')
text(40,0.2,'Stablecoin - Online', 'FontWeight','bold')
title('Incorporated cost $tc_H$ = 2\%, $tc_L$ = 4\% - Separating contract','Interpreter','latex','FontName','Times New Roman','FontSize',16)
xlabel('q - Probability of banking exploitation (percentage of H-sellers)')
ylabel('Adverse selection extent (\lambda - absconding payoff )')

grey = "#808080";
subplot(1,2,2)
plot(Lam2(:), 'Color', grey,'LineWidth',2);
hold on
x=1:1:21;
plot(x,root_STA_OND_1(x,5,3), 'k');
hold on
x=21:1:100;
plot(x,root_STA_OND_1(x,5,3), '--k');
hold on
x = 92:1:100;
plot(x,root_STA_PART_3_1(x,5,3), 'r');
hold on
x = 89:1:92;
plot(x,root_STA_PART_3_1(x,5,3), '--r');
text(3,0.68,'Deposit', 'FontWeight','bold')
text(3,0.65,'Online', 'FontWeight','bold')
text(35,0.7,'Separating contract', 'FontWeight','bold')
text(40,0.2,'Stablecoin - Online', 'FontWeight','bold')
text(69,0.4,'Cash offline \leftarrow', 'FontWeight','bold')
title('Incorporated cost $tc_H$ = 2\%, $tc_L$ = 4\% - Partial pooling contract','Interpreter','latex','FontName','Times New Roman','FontSize',16)
xlabel('q - Probability of banking exploitation (percentage of H-sellers)')
ylabel('Adverse selection extent (\lambda - absconding payoff )')

%--------------------------------------------------------------
%--------------------------------------------------------------
%--------------------CBDC, CASH AND DEPOSIT -------------------
figure
plot(Lam1(1:37),"--b");
hold on
plot(Lam2(:),'-r','LineWidth',2);
hold on
plot(Lam3(:),"--b");
hold on
plot(con(:),':c');
hold on
plot(Lam10(:),'-.g');
hold on
plot(con1(:), ':m');
text(39,0.74,'ON-CBDC')
text(40,0.48,'OFF-C separating')
text(40,0.6,'ON-CBDC')
text(40,0.2,'ON-CBDC')
text(4,0.4,'ON-CBDC')
title('\lambda with CBDC-online payment','FontName','Times New Roman','FontSize',16)
xlabel('q - percentage of H-sellers')
%--------------------------------------------------------------------
%--------------------------------------------------------------------
%------------------- INCORPORATED COST ------------------------------
%------(No competition and No cooperation)--------------------------
for x = 1:100
    Line_STA_SEP (x)= Res_STA_SEP(x,1,1) ;
end
    figure
subplot(1,4,1)
plot(Lam1(1:37),"b");
hold on
plot(Lam2(:),'r','LineWidth',2);
hold on
plot(Lam3(:),"b");
hold on
plot(con(:),'c');
hold on
plot(Res_STA_OND(:,1,1), 'k');
hold on
plot(Res_STA_SEP(:,1,1), 'g');
hold on
plot(Res_STA_PART(:,1,1), 'r');
text(30,0.73,'Stablecoins - Online')
text(40,0.48,'Cash offline')
text(39,0.44,'Sep. Contract')
text(40,0.2,'Stablecoins - Online')
title('Transaction fee = $0\%p$ ','Interpreter','latex','FontName','Times New Roman','FontSize',16)
xlabel('q - percentage of H-sellers')
ylabel('\lambda- absconding payoff')

for x = 1:100
    Sta_Dep_002(x) = root_STA_OND_1(x, 3,3);
end
for x = 1:100
    Sta_Part_002(x) = root_STA_PART_3_1(x, 3, 3);
end
for x = 1:100
    Line_STA_SEP_2 (x)= root_STA_SEP_2_2(x,3,3) ;
end
x3 = linspace(28,81,54);
x4 = [x3,  flipud(x3)];
subplot(1,4,2)
plot(Lam2(:),'r','LineWidth',2);
hold on
plot(Lam3(:),'b');
%hold on
%plot(Lam1(1:38),'--b');
hold on
plot(con(:),'c');
hold on
x=22:1:100;
plot(x,root_STA_OND_1(x,3,3), 'k');
hold on
x=1:1:16;
plot(x,root_STA_OND_1(x,3,3), 'k');
hold on
x=22:1:100;
plot(x,root_STA_SEP_2_2(x,3,3), 'g');
hold on
x = 89:1:100;
plot(x, root_STA_PART_3_1(x,3,3), 'r');
text(3,0.68,'Deposit')
text(3,0.65,'Online')
text(31,0.67,'Stablecoin - Online')
text(40,0.48,'Cash offline')
text(39,0.45,'(Sep. Contract)')
text(40,0.2,'Stablecoin - Online')
text(69,0.4,'Cash offline \leftarrow')
text(67,0.37,'(Partial contract)') 
title('Transaction fee $tc_H$ = $tc_L= 2\%p$ ','Interpreter','latex','FontName','Times New Roman','FontSize',16)
xlabel('q - percentage of H-sellers')
ylabel('\lambda- absconding payoff')


for x = 1:100
    Sta_Dep_003(x) = root_STA_OND_1(x, 3,5);
end
for x = 1:100
    Sta_Part_003(x) = root_STA_PART_3_1(x, 3, 5);
end
for x = 1:100
    Line_STA_SEP_3 (x)= root_STA_SEP_2_2(x,3,5) ;
end
subplot(1,4,3)
plot(Lam2(:),'r','LineWidth',2);
hold on
plot(Lam3(:),'b');
% hold on
% plot(Lam1(1:38),'--b');
hold on
plot(con(:),':c');
hold on
x=27:1:81;
plot(x,root_STA_OND_1(x,3,5), 'k');
hold on
x=1:1:20;
plot(x,root_STA_OND_1(x,3,5), 'k');
hold on
x=27:1:81;
plot(x,root_STA_SEP_2_2(x,3,5), 'g');
hold on
x = 82:1:100;
plot(x,root_STA_PART_3_1(x,3,5), 'r');
text(3,0.68,'Deposit')
text(3,0.65,'Online')
text(35,0.7,'Stablecoin')
text(35,0.67,'Online')
text(40,0.51,'Cash offline')
text(39,0.48,'(Sep. Contract)')
text(40,0.2,'Stablecoin - Online')
text(59,0.3, 'Cash offline \leftarrow')
text(54,0.27, '(Partial contract)')
title('Transaction fee, $tc_H = 4\%p$, $tc_L = 2\%p$ ','Interpreter','latex','FontName','Times New Roman','FontSize',16)
xlabel('q - percentage of H-sellers')
ylabel('\lambda- absconding payoff')

for x = 1:100
    Sta_Dep_004(x) = root_STA_OND_1(x,5,3);
end
for x = 1:100
    Sta_Part_004(x) = root_STA_PART_3_1(x,5,3);
end
for x = 1:100
    Line_STA_SEP_4 (x)= root_STA_SEP_2_2(x,5,3) ;
end
subplot(1,4,4)
plot(Lam2(:),'-r','LineWidth',2);
hold on
plot(Lam3(:),'b');
% hold on
% plot(Lam1(1:38),'--b');
hold on
plot(con(:),'c');
hold on
x = 27:1:95;
plot(x,root_STA_SEP_2_2(x,5,3), 'g');
hold on
x=1:1:21;
plot(x,root_STA_OND_1(x,5,3), 'k');
hold on
x=27:1:100;
plot(x,root_STA_OND_1(x,5,3), 'k');
hold on
x = 92:1:100;
plot(x,root_STA_PART_3_1(x,5,3), 'r');
text(3,0.68,'Deposit')
text(3,0.65,'Online')
text(35,0.7,'Stablecoin')
text(35,0.67,'Online')
text(40,0.51,'Cash offline')
text(39,0.48,'(Sep. Contract)')
text(40,0.2,'Stablecoin - Online')
title('Transaction fee $tc_H = 2\%p$, $tc_L = 4\%p$ ','Interpreter','latex','FontName','Times New Roman','FontSize',16)
xlabel('q - percentage of H-sellers')
ylabel('\lambda- absconding payoff')

%------------------------------------------------------------------------
%------------------ NARROW BANKS INTRODUCED-----------------------------
%------- No COOPERATION: deposit charge fee => deposit and stablecoin are
% the same, sellers choose whichever got the lower transaction fee
figure
subplot(1,3,1)
plot(Lam2(:),'r','LineWidth',2);
hold on
plot(con(:),'c');
hold on
x=1:1:16;
plot(x,root_STA_OND_1(x,3,3), 'k');
hold on
x=20:1:100;
plot(x,root_STA_SEP_2_2(x,2,2), 'g');
hold on
x = 89:1:100;
plot(x, root_STA_PART_3_1(x,2,2), 'r');
text(35,0.67,'Online Payment', 'FontWeight', 'bold')
text(40,0.48,'Cash offline','FontWeight', 'bold')
text(39,0.45,'(Sep. Contract)','FontWeight', 'bold')
text(40,0.2,'Online Payment','FontWeight', 'bold')
text(69,0.4,'Cash offline \leftarrow','FontWeight', 'bold')
text(67,0.37,'(Partial contract)','FontWeight', 'bold') 
title('Transaction fee $tc_H$ = $tc_L$= 1\%p ','Interpreter','latex','FontName','Times New Roman','FontSize',16)
xlabel('q - Probability of banking exploitation (percentage of H-sellers)')
ylabel('Adverse selection extent (\lambda - absconding payoff )')
subplot(1,3,2)
plot(Lam2(:),'r','LineWidth',2);
hold on
x=1:1:16;
plot(x,root_STA_OND_1(x,3,3), 'k');
plot(con(:),'c');
hold on
x=20:1:100;
plot(x,root_STA_SEP_2_2(x,3,3), 'g');
hold on
x = 89:1:100;
plot(x, root_STA_PART_3_1(x,3,3), 'r');
text(2,0.67,'Deposit', 'FontWeight', 'bold')
text(2,0.62,'(Lending bank)', 'FontWeight', 'bold')
text(35,0.67,'Online Payment', 'FontWeight', 'bold')
text(40,0.48,'Cash offline','FontWeight', 'bold')
text(39,0.45,'(Sep. Contract)','FontWeight', 'bold')
text(40,0.2,'Online Payment','FontWeight', 'bold')
text(69,0.4,'Cash offline \leftarrow','FontWeight', 'bold')
text(67,0.37,'(Partial contract)','FontWeight', 'bold') 
title('Transaction fee $tc_H$ = $tc_L$= 2\%p ','Interpreter','latex','FontName','Times New Roman','FontSize',16)
xlabel('q - Probability of banking exploitation (percentage of H-sellers)')
ylabel('Adverse selection extent (\lambda - absconding payoff )')
subplot(1,3,3)
plot(Lam2(:),'r','LineWidth',2);
hold on
plot(con(:),'c');
hold on
x = 10:1:29;
plot(x,Lam3(x), 'y');
hold on
x=1:1:21;
plot(x,root_STA_OND_1(x,5,3), 'g');
hold on
x=29:1:50;
plot(x,root_STA_OND_1(x,5,3), 'g');
hold on
x=29:1:100;
plot(x,root_STA_SEP_2_2(x,5,3), 'g');
hold on
x = 89:1:100;
plot(x, root_STA_PART_3_1(x,5,3), 'r');
text(35,0.67,'Online Payment', 'FontWeight', 'bold')
text(40,0.48,'Cash offline','FontWeight', 'bold')
text(39,0.45,'(Sep. Contract)','FontWeight', 'bold')
text(40,0.2,'Online Payment','FontWeight', 'bold')
text(69,0.4,'Cash offline \leftarrow','FontWeight', 'bold')
text(67,0.37,'(Partial contract)','FontWeight', 'bold') 
text(2,0.67,'Deposit', 'FontWeight', 'bold')
text(2,0.62,'(Lending bank)', 'FontWeight', 'bold')
title('Transaction fee $tc_H = 2\%p$, $tc_L= 4\%p$ ','Interpreter','latex','FontName','Times New Roman','FontSize',16)
xlabel('q - Probability of banking exploitation (percentage of H-sellers)')
ylabel('Adverse selection extent (\lambda - absconding payoff )')
sgtitle('No Cooperation between Lending bank and Deposit bank. Sellers choose Online payment which is either stablecoin or depost which ever is cheaper') 

figure
% plot(Res_STA_SEP(:),'y');
% hold on
plot(root_STA_PART_3_2(:,3,3), 'g');
hold on
% x=800:1:801;
% plot(x,root_lambda_2_2(x,5,5), 'or');
% hold on
plot(root_STA_PART_3_1(:,3,3), 'b');
legend('STA(above) Part 3_2 2%','STA(above) Part 3_1 2%') 
xlabel('q - percentage of H-sellers')
ylabel('\lambda- absconding payoff')
% 

%----------------------------------------------------------------------
%----------------------------------------------------------------------
%-----------------NEW BUYER 'S MARKET POWER ---------------------------
%------------------- INCORPORATED COST ------------------------------
%------(No competition and No cooperation)--------------------------
for x = 1:100
    Line_STA_SEP (x)= Res_STA_SEP(x,1,1) ;
end
    figure
subplot(1,4,1)
plot(Lam1(1:37),"b");
hold on
plot(Lam2(:),'r','LineWidth',2);
hold on
plot(Lam3(:),"b");
hold on
plot(con(:),'c');
hold on
plot(Res_STA_OND(:,1,1), 'k');
hold on
plot(Res_STA_SEP(:,1,1), 'g');
hold on
plot(Res_STA_PART(:,1,1), 'r');
text(30,0.73,'Stablecoins - Online')
text(40,0.48,'Cash offline')
text(39,0.44,'Sep. Contract')
text(40,0.2,'Stablecoins - Online')
title('Transaction fee = $0\%p$ ','Interpreter','latex','FontName','Times New Roman','FontSize',16)
xlabel('q - percentage of H-sellers')
ylabel('\lambda- absconding payoff')

for x = 1:100
    Sta_Dep_002(x) = root_STA_OND_1(x, 3,3);
end
for x = 1:100
    Sta_Part_002(x) = root_STA_PART_3_1(x, 3, 3);
end
for x = 1:100
    Line_STA_SEP_2 (x)= root_STA_SEP_2_2(x,3,3) ;
end
x3 = linspace(28,81,54);
x4 = [x3,  flipud(x3)];
subplot(1,4,2)
plot(Lam2(:),'r','LineWidth',2);
hold on
plot(Lam3(:),'b');
%hold on
%plot(Lam1(1:38),'--b');
hold on
plot(con(:),'c');
hold on
x=1:1:100;
plot(x,root_STA_OND_1(x,3,3), 'k');
hold on
x=1:1:100;
plot(x,root_STA_OND_1(x,3,3), 'k');
hold on
x=1:1:100;
plot(x,root_STA_SEP_2_2(x,3,3), 'g');
hold on
x = 1:1:100;
plot(x, root_STA_PART_3_1(x,3,3), 'r');
text(3,0.68,'Deposit')
text(3,0.65,'Online')
text(31,0.67,'Stablecoin - Online')
text(40,0.48,'Cash offline')
text(39,0.45,'(Sep. Contract)')
text(40,0.2,'Stablecoin - Online')
text(69,0.4,'Cash offline \leftarrow')
text(67,0.37,'(Partial contract)') 
title('Transaction fee $tc_H$ = $tc_L= 2\%p$ ','Interpreter','latex','FontName','Times New Roman','FontSize',16)
xlabel('q - percentage of H-sellers')
ylabel('\lambda- absconding payoff')


for x = 1:100
    Sta_Dep_003(x) = root_STA_OND_1(x, 3,5);
end
for x = 1:100
    Sta_Part_003(x) = root_STA_PART_3_1(x, 3, 5);
end
for x = 1:100
    Line_STA_SEP_3 (x)= root_STA_SEP_2_2(x,3,5) ;
end
subplot(1,4,3)
plot(Lam2(:),'r','LineWidth',2);
hold on
plot(Lam3(:),'b');
% hold on
% plot(Lam1(1:38),'--b');
hold on
plot(con(:),':c');
hold on
x=1:1:100;
plot(x,root_STA_OND_1(x,3,5), 'k');
hold on
x=1:1:100;
plot(x,root_STA_OND_1(x,3,5), 'k');
hold on
x=1:1:100;
plot(x,root_STA_SEP_2_2(x,3,5), 'g');
hold on
x = 1:1:100;
plot(x,root_STA_PART_3_1(x,3,5), 'r');
text(3,0.68,'Deposit')
text(3,0.65,'Online')
text(35,0.7,'Stablecoin')
text(35,0.67,'Online')
text(40,0.51,'Cash offline')
text(39,0.48,'(Sep. Contract)')
text(40,0.2,'Stablecoin - Online')
text(59,0.3, 'Cash offline \leftarrow')
text(54,0.27, '(Partial contract)')
title('Transaction fee, $tc_H = 4\%p$, $tc_L = 2\%p$ ','Interpreter','latex','FontName','Times New Roman','FontSize',16)
xlabel('q - percentage of H-sellers')
ylabel('\lambda- absconding payoff')

for x = 1:100
    Sta_Dep_004(x) = root_STA_OND_1(x,5,3);
end
for x = 1:100
    Sta_Part_004(x) = root_STA_PART_3_1(x,5,3);
end
for x = 1:100
    Line_STA_SEP_4 (x)= root_STA_SEP_2_2(x,5,3) ;
end
subplot(1,4,4)
plot(Lam2(:),'-r','LineWidth',2);
hold on
plot(Lam3(:),'b');
% hold on
% plot(Lam1(1:38),'--b');
hold on
plot(con(:),'c');
hold on
x = 1:1:100;
plot(x,root_STA_SEP_2_2(x,5,3), 'g');
hold on
x=1:1:100;
plot(x,root_STA_OND_1(x,5,3), 'k');
hold on
x=1:1:100;
plot(x,root_STA_OND_1(x,5,3), 'k');
hold on
x = 1:1:100;
plot(x,root_STA_PART_3_1(x,5,3), 'r');
text(3,0.68,'Deposit')
text(3,0.65,'Online')
text(35,0.7,'Stablecoin')
text(35,0.67,'Online')
text(40,0.51,'Cash offline')
text(39,0.48,'(Sep. Contract)')
text(40,0.2,'Stablecoin - Online')
title('Transaction fee $tc_H = 2\%p$, $tc_L = 4\%p$ ','Interpreter','latex','FontName','Times New Roman','FontSize',16)
xlabel('q - percentage of H-sellers')
ylabel('\lambda- absconding payoff')
