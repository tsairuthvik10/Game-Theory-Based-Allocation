load distance.mat;
load gain.mat;
D=20;
U=10;
N=20;
Do=10;
Pn=1;
for d=1:D
PL(d)=(35.68+38*log10(d7(d)));%pathloss for distance of 0-400m
Beta(d)=PL(d)/Pn;%inter-user interference
PL1(d)=(35.68+38*log10(d8(d)));%pathloss for distance of 0-200m
Beta1(d)=PL1(d)/Pn;%inter-user interference
end

plot(d7,Beta,'-b')
hold on
plot(d8,Beta1,'-r')
legend('400m from BS', '200m from BS')

%theorem 1(checking for nash equilibrium)
for n=1:N
    for u=1:U
        for d=1:Do
    b=min(hun(u,n)*hdn(d,n)/gud(u,d));
        end
    end
end

%as beta is way less than 0.2316(b), there exists a nash equilibrium




