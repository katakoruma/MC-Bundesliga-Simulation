clear

ST = zeros(4,18);

%%

n = 1000

%ST(1,:) = [100,95,90,85,80,75,70,65,60,55,50,45,40,35,30,25,20,15]   ;  %Stärke Heim
%ST(2,:) = [100,95,90,85,80,75,70,65,60,55,50,45,40,35,30,25,20,15]   ;  %Verteidigung Heim

% ST(3,:) = [95,90,85,80,75,70,65,60,55,50,45,40,35,30,25,20,15,10]   ;   %Stärke Auswaerts
% ST(4,:) = [95,90,85,80,75,70,65,60,55,50,45,40,35,30,25,20,15,10]   ;   %Verteidigung Auswaerts

ST(1,:) = 54   ;
ST(2,:) = 52   ;

ST(3,:) = 50   ;
ST(4,:) = 48   ;

ExST = [10,2,8,1]   ;%[MaxST,MinST,MaxVE,MinVE]

%ExST = [100,20,45,10]   ;

%ExST = [100,0,0,0]   ;

%%

E = zeros(18,18,2,n);

TP = zeros(18,18,2,n);
TS = zeros(18,18,2,n); 

ExST
ST

 for k = 1:n
     for i = 1:18
        for j = 1:18

            if i == j
                
                E(i,j,:,k) = "";
                TP(i,j,:,k) =  "";
                TS(i,j,:,k) =  "";
                
                continue
            else
                
               p1 = ((ExST(1)-ExST(2))/100) * ST(1,i) + ExST(2) - ( ((ExST(3)-ExST(4))/100) * ST(4,j) + ExST(4) );
               
               if p1 < 0
                   p1 = 0;
               end
               
               p2 = ((ExST(1)-ExST(2))/100) * ST(3,j) + ExST(2) - ( ((ExST(3)-ExST(4))/100) * ST(2,i) + ExST(4) );
               
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

R=zeros(19,9);

Ss=zeros(18,n);
Ns=zeros(18,n);
Us=zeros(18,n);
Ps=zeros(18,n);

R2=zeros(19,9,n);
Rs2=zeros(19,9,n);
Rp2=zeros(19,n+1);

G=zeros(19,19);

Es=zeros(19,5,2);

%%

for i = 1:n 
    for j = 1:18
            
        R2(j+1,2,i) = sum(TS(j,:,1,i) == 1) + sum(TS(j,:,2,i) == 1);
        R2(j+1,3,i) = sum(TS(j,:,1,i) == 0) + sum(TS(j,:,2,i) == 0);
        R2(j+1,4,i) = sum(TS(j,:,1,i) == -1) + sum(TS(j,:,2,i) == -1);
        
        R2(j+1,6,i) = sum(TS(j,:,1,i) == 1);
        R2(j+1,7,i) = sum(TS(j,:,1,i) == -1);
        
        R2(j+1,8,i) = sum(TS(j,:,2,i) == 1);
        R2(j+1,9,i) = sum(TS(j,:,2,i) == -1);
        
        R2(j+1,5,i) = sum(TP(j,:,1,i) == 3) * 3 + sum(TP(j,:,1,i) == 1) + sum(TP(j,:,2,i) == 3) * 3 + sum(TP(j,:,2,i) == 1);
        
    end
    
    Ss(:,i) = sort(R2(2:19,2,i), 'descend');
    Us(:,i) = sort(R2(2:19,3,i), 'descend');
    Ns(:,i) = sort(R2(2:19,4,i), 'descend');
    Ps(:,i) = sort(R2(2:19,5,i), 'descend');
    
    [Rs2(2:19,2:9,i),Rp2(2:19,i+1)] = sortrows(R2(2:19,2:9,i),[4,1,2,3], {'descend','descend','descend','ascend'});
    
end

for i = 1:18
        
    R(i+1,2) = sum(R2(i+1,2,:));
    R(i+1,3) = sum(R2(i+1,3,:));
    R(i+1,4) = sum(R2(i+1,4,:));
    R(i+1,5) = sum(R2(i+1,5,:));
    R(i+1,6) = sum(R2(i+1,6,:));
    R(i+1,7) = sum(R2(i+1,7,:));
    R(i+1,8) = sum(R2(i+1,8,:));
    R(i+1,9) = sum(R2(i+1,9,:));
    
    Es(i+1,2,1) = mean(Ss(i,:));
    Es(i+1,2,2) = sqrt(var(Ss(i,:)));
    Es(i+1,3,1) = mean(34-(Ss(i,:)+Ns(19-i,:)));  %mean(Us(i,:))
    Es(i+1,3,2) = sqrt(var(34-(Ss(i,:)+Ns(19-i,:))));   %var(Us(i,:))
    Es(i+1,4,1) = mean(Ns(19-i,:));
    Es(i+1,4,2) = sqrt(var(Ns(19-i,:)));
    Es(i+1,5,1) = mean(Ps(i,:));
    Es(i+1,5,2) = sqrt(var(Ps(i,:)));
    
    for j = 1:18
    
        G(j+1,i+1) = sum(Rp2(j+1,:) == i);
        
    end
    
end

R = R/n;
Gn = G/n;

Es(2:19,1,1) = 1:18;
Es(2:19,1,2) = 1:18;
G(2:19,1) = 1:18;
Gn(2:19,1) = 1:18;

R = num2cell(R);
Es = num2cell(Es);
G = num2cell(G);
Gn = num2cell(Gn);

R(2:19,1) = {'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R'};
G(1,2:19) = {'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R'};
Gn(1,2:19) = {'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R'};
Es(1,:,1) = {'','S','U','N','P'};
Es(1,:,2) = {'','S','U','N','P'};
R(1,:) = {'','S','U','N','P','HS','HN','AS','AN'};

R(2:19,:) = sortrows(R(2:19,:),[5,2,3,4], {'descend','descend','descend','ascend'});

%%

disp("R = ")
disp([R])

disp("Gn = ")
disp([Gn])

disp('Erwartungswert = ')
disp([Es(:,:,1)])
disp('Standardabweichung = ')
disp([Es(:,:,2)])

disp("G = ")
disp([G])

 %%                 
                   
 figure(1)                  
 histogram(Ps(1,:),max(1,ceil(max(Ps(1,:))-min(Ps(1,:)))),'Normalization','probability')
 
 figure(2)
 histogram(Ps(18,:),max(1,ceil(max(Ps(18,:))-min(Ps(18,:)))),'Normalization','probability')
 
 figure(3)
 histogram(Ps(1,:)-Ps(2,:),max(1,ceil(max(Ps(1,:)-Ps(2,:))-min(Ps(18,:)-Ps(2,:))+1)),'Normalization','probability')
 
 figure(4)
 histogram(Rp2(2,2:n+1),max(1,ceil(max(Rp2(2,2:n+1))-min(Rp2(2,2:n+1))+1)))
          