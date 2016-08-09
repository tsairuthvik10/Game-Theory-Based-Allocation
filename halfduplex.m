% N=20; %total no. of sub-carriers
% U=10; %total no. of uplink channels
% D=10; %total no. of downlink channels
% noisee=9000;
% noiseb=9000;
% Pn=1.5;
% Pun=2.3;
%all the powers are in dB

load gain.mat;
load finalpower.mat;
values;
beta=10^(-10); %self-interference factor at BS in watts

%calculating inter-user interference for downlink
for u=1:U
    for d=1:D   
        for n=1:N
         Interd(d,n)=Pun(u,n)*gud(u,d);
        end
         %T(d)= hdn(d)./(noisee + Inter(d));  
    end
end

%calculating inter-user interference for uplink
for u=1:U-1
    for d=u+1:U   
        for n=1:N
         Interu(u,n)=Pdn(d,n)*hdn(d,n);
        end
         %T(d)= hdn(d)./(noisee + Inter(d));  
    end
end

for n=1:N
    for d=1:D
%for uplink channel, the user rate on a sub-carrier is Ru(n)
        Rd(d,n)= log2(1 + (Pn(n)*hdn(d,n))/(noisee + Interd(d,n)));
    end
%for downlink channel, the user rate on a sub-carrier is Rd(n)
for u=1:U-1
        Ru(u,n)= log2((1 + (Pun(u,n)*hun(u,n))/(noiseb + Pn(n)*beta + Interu(u,n))));
end
Rdmax(n)=max(Rd(d,n));
Rumax(n)=max(Ru(u,n));
ur(n)=Rumax(n)+Rdmax(n);%sumrate=Ru(n)+Rd(n)

end
cdfplot(ur)%(cdf vs sumrate)


            