D=10;
U=10;
N=20;
Pni=0.1;%initial power(lambda)
noisee=(3.981*10^(-18)*10*10^(6))/20;
noiseb=(3.981*10^(-18)*10*10^(6))/20;
% as for each self interference factor, a cdf has to be plotted against user rate,we use different 
% values of beta
beta=10^(-10); %self-interference factor at BS
%beta=10^(-7);
%beta=10^(-8);
%beta=10^(-8.5);
%beta=10^(-9);
load gain.mat;
load finalpower.mat;

%optimal power allocation strategy for the uplink users given the downlink subcarrier and power allocation


%1. calculating inter-user interference for uplink
for u=1:U
    for d=1:D   
        for n=1:N
         Interd(d,n)=Pun(u,n)*gud(u,d);
        end 
    end
end
%2.getting the positions of each of the channels with the highest SNR
for n=1:N
    T(n)= hdn(n)./(noisee + Interd(n));
end
n=find(T==max(T));
    if length(n)>1 
        n=n(1); %taking one occurence at a time
    end


%3.Calculating hdln for power allocation
for u=1:U
    for d=1:D
        for n=1:N
        hdln(d,n)=(hdn(d,n)/(noisee + Interd(d,n)));
        end
    end
    %hdln(u)=max(hdln(u,:));
end

for n=1:N
    hdlnm(n)=max(hdln(:,n));
end
%downlink power allocation
for d=1:D

R(d)=abs((1/Pni)-(1/hdln(d)));
Pnf(d)=max(0,R(d));
end

%optimal power allocation strategy for the downlink users given the uplink power allocation


%1. calculating inter-user interference for uplink
for u=1:U-1
    for d=u+1:U  
        for n=1:N
         Interu(u,n)=Pdn(d,n)*hdn(d,n);
        end
         %T(d)= hdn(d)./(noisee + Inter(d));  
    end
end
%2. calculating the huln for uplink power allov=cation
for d=1:D
    for u=1:U-1
        for n=1:N
        huln(u,n)=(hun(u,n)/(noisee + Interu(u,n) + Pn(n)*beta));
        end
    end
end

for n=1:N
    hulnm(n)=max(huln(:,n));
end
%3.uplink power allocation
for d=1:D
for u=1:U-1
Pns(u)=Pni-R(d);%initial power given for downlink power allocation - downlink power
S(u)=abs((1/Pns(u))-(1/huln(u)));
Pnsf(u)=max(0,S(u));
end
end

%calcuating user rate for 1 uplink and 1 downlink channel
RUL(1)=log2(1 + Pnsf(u)*hulnm(1));
    RDL(1)=log2(1 + Pnf(d)*hdlnm(1));
    USERRATE(1)=RUL(1)+RDL(1);
    
%calcuating user rate for uplink and downlink channel    
for n=2:N

    RUL(n)=log2(1 + Pnsf(u)*hulnm(n));
    RDL(n)=log2(1 + Pnf(d)*hdlnm(n));
    USERRATE(n)=RUL(n)+RDL(n);
   
   if ((USERRATE(n)/USERRATE(n-1))< 0.00001)
       break
   end
end

%calculating gain in spectral efficiency between two successive iterations 
for n=2:N
       avggain(n)=(USERRATE(n)/USERRATE(n-1));
end


%if you want to see the plots of uplink user rate (RUL) and downlink user
%rate (RDL),remove the commnets below and comment on cdfplot and then save
%the file and run it.

% plot(RUL,'-ob')
% hold on
% plot(RDL,'->r')
 cdfplot(USERRATE);%(cdf vs sumrate)
% h1=cdfplot(USERRATE);
[h, stats] = cdfplot(USERRATE);
 %hold on
M=[1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20];
%plot(M,avggain,'sb');

