clear

ST1 = zeros(1,18);
VE1 = zeros(1,18);
ST2 = zeros(1,18);
VE2 = zeros(1,18);

%%


% ST1(:) = [100,95,90,85,80,75,70,65,60,55,50,45,40,35,30,25,20,15]   ;
% VE1(:) = [100,95,90,85,80,75,70,65,60,55,50,45,40,35,30,25,20,15]   ;
% 
% ST2(:) = [95,90,85,80,75,70,65,60,55,50,45,40,35,30,25,20,15,10]   ;
% VE2(:) = [95,90,85,80,75,70,65,60,55,50,45,40,35,30,25,20,15,10]   ;

ST1(:) = 54   ;
VE1(:) = 52   ;

ST2(:) = 50   ;
VE2(:) = 48   ;

% ST1(1) = 180  ;
% VE1(1) = 100  ;
%  
% ST2(1) = 100  ;
% VE2(1) = 100  ;

a = 1.8 %3.5
b = 1.2 %2.9

n = 1000

maxST=10;
minST=2;

maxVE=8;
minVE=1;

%%

E = zeros(18,18,2,n);

TP = zeros(18,18,2,n);
TS = zeros(18,18,2,n); 

ST1
VE1
ST2
VE2

 for k = 1:n
     for i = 1:18
        for j = 1:18

            if i == j
                
                E(i,j,:,k) = "";
                TP(i,j,:,k) =  "";
                TS(i,j,:,k) =  "";
                
                continue
            else
                
               p1 = ((maxST-minST)/100) * ST1(i) + minST - ( ((maxVE-minVE)/100) * VE2(j) + minVE );
               
               if p1 < 0
                   p1 = 0;
               end
               
               p2 = ((maxST-minST)/100) * ST2(j) + minST - ( ((maxVE-minVE)/100) * VE1(i) + minVE );
               
               if p2 < 0
                   p2 = 0;
               end
                
               E(i,j,1,k) = poissrnd(p1);
               E(j,i,2,k) = poissrnd(p2);
               
               if E(i,j,1,k) < E(j,i,2,k)
                   
                   TP(i,j,1,k) =  0;
                   TS(i,j,1,k) =  -1;
                   
                   TP(j,i,2,k) =  3;
                   TS(j,i,2,k) =  1;
                   
               end
                   
               if E(i,j,1,k) > E(j,i,2,k)
                   
                   TP(i,j,1,k) =  3;
                   TS(i,j,1,k) =  1;
                   
                   TP(j,i,2,k) =  0;
                   TS(j,i,2,k) =  -1;
                   
               end
               
               if E(i,j,1,k) == E(j,i,2,k)
                   
                   TP(i,j,1,k) =  1;
                   TS(i,j,1,k) =  0;
                   
                   TP(j,i,2,k) =  1;
                   TS(j,i,2,k) =  0;
                   
               end
            end
            
        end
     end
 end
%%

S=zeros(18,n+1);
N=zeros(18,n+1);
U=zeros(18,n+1);

HS=zeros(18,n+1);
HN=zeros(18,n+1);

AS=zeros(18,n+1);
AN=zeros(18,n+1);

P=zeros(18,n+1);

R=zeros(19,9);

%%

for i = 1:n 
    for j = 1:18

        S(j,i+1) = sum(TS(j,:,1,i) == 1) + sum(TS(j,:,2,i) == 1);
        N(j,i+1) = sum(TS(j,:,1,i) == -1) + sum(TS(j,:,2,i) == -1);
        U(j,i+1) = sum(TS(j,:,1,i) == 0) + sum(TS(j,:,2,i) == 0);
        
        HS(j,i+1) = sum(TS(j,:,1,i) == 1);
        HN(j,i+1) = sum(TS(j,:,1,i) == -1);
        
        AS(j,i+1) = sum(TS(j,:,2,i) == 1);
        AN(j,i+1) = sum(TS(j,:,2,i) == -1);
        
        P(j,i+1) = sum(TP(j,:,1,i) == 3) * 3 + sum(TP(j,:,1,i) == 1) + sum(TP(j,:,2,i) == 3) * 3 + sum(TP(j,:,2,i) == 1);
    
    end
end

Ss = sort(S, 'descend');
Ns = sort(N, 'descend');
Us = sort(U, 'descend');
Ps = sort(P, 'descend');

Ss(:,1) = [];
Ns(:,1) = [];
Us(:,1) = [];
Ps(:,1) = [];

Es = zeros(19,5,2);

for i = 1:18
        
    R(i+1,2) = sum(S(i,:));
    R(i+1,3) = sum(U(i,:));
    R(i+1,4) = sum(N(i,:));
    R(i+1,5) = sum(P(i,:));
    R(i+1,6) = sum(HS(i,:));
    R(i+1,7) = sum(AS(i,:));
    R(i+1,8) = sum(HN(i,:));
    R(i+1,9) = sum(AN(i,:));
    
    Es(i+1,2,1) = mean(Ss(i,:));
    Es(i+1,2,2) = var(Ss(i,:));
    Es(i+1,3,1) = mean(34-(Ss(i,:)+Ns(19-i,:)));  %mean(Us(i,:))
    Es(i+1,3,2) = var(34-(Ss(i,:)+Ns(19-i,:)));   %var(Us(i,:))
    Es(i+1,4,1) = mean(Ns(19-i,:));
    Es(i+1,4,2) = var(Ns(19-i,:));
    Es(i+1,5,1) = mean(Ps(i,:));
    Es(i+1,5,2) = var(Ps(i,:));
    
end

R = R/n;
 
R = num2cell(R);
S = num2cell(S);
N = num2cell(N);
U = num2cell(U);
P = num2cell(P);
Es = num2cell(Es);

R(2:19,1) = {'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R'};
S(:,1) = {'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R'};
N(:,1) = {'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R'};
U(:,1) = {'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R'};
P(:,1) = {'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R'};
Es(2:19,1,1) = {'1.','2.','3.','4.','5.','6.','7.','8.','9.','10.','11.','12.','13.','14.','15.','16.','17.','18.'};
Es(2:19,1,2) = {'1.','2.','3.','4.','5.','6.','7.','8.','9.','10.','11.','12.','13.','14.','15.','16.','17.','18.'};
Es(1,:,1) = {'','S','U','N','P'};
Es(1,:,2) = {'','S','U','N','P'};

R(2:19,:) = sortrows(R(2:19,:),[5,2,3,4], {'descend','descend','descend','ascend'});

R(1,:) = {'','S','U','N','P','HS','AS','HN','AN'};

%%

f=[];

f(:,1) = cell2mat(R(2:19,6));
f(:,2) = cell2mat(R(2:19,3));
f(:,3) = cell2mat(R(2:19,7));
f(:,4) = cell2mat(R(2:19,2));
f(:,5) = cell2mat(R(2:19,3));

f(:,1) = f(:,1)./(f(:,4)+f(:,5)) * 100;
f(:,2) = f(:,2)./(f(:,4)+f(:,5)) * 100;
f(:,3) = f(:,3)./(f(:,4)+f(:,5)) * 100;

disp("R = ")
disp([R])
disp("E = ")
disp([E(:,:,:,1)])
disp("f = ")
disp([f(:,1:3)])
