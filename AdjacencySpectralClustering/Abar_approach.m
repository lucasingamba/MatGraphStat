clc, clear

load('/Users/jovo/Research/projects/papers/priority/ind_edge_classifier/data/BLSA0317_Count_Lhats.mat')

%%
% 
AA=As;
for i=1:49
    AA(:,:,i)=AA(:,:,i)+AA(:,:,i)';
end

A0=mean(AA(:,:,constants.y0),3);
A1=mean(AA(:,:,constants.y1),3);
eps=1/(10*constants.s);

params.lnprior0=log(constants.s0/constants.s);
params.lnprior1=log(constants.s1/constants.s);

% clear LhatN
% dims=1:40; %unique(round(logspace(0,log10(70),10)));
% for k=2:10;
%     icount=0;
%     for i=dims(1:k)
%         lat0 = estimate_latent_features_eig(A0, i);
%         lat1 = estimate_latent_features_eig(A1, i);
%         
%         
%         T0 = clusterdata(lat0,k);
%         T1 = clusterdata(lat1,k);
%         
%         centroid0=nan(k,i);
%         centroid1=nan(k,i);
%         for j=1:k
%            centroid0(j,:)=mean(lat0(T0==j,:),1); 
%            centroid1(j,:)=mean(lat1(T1==j,:),1); 
%         end
%         
%         [IDX0 C0] = kmeans(lat0,k,'start',centroid0);
%         [IDX1 C1] = kmeans(lat1,k,'start',centroid1);
%         
%         
%         
%         E0=C0(IDX0,:)*C0(IDX0,:)';
%         E0(E0<=0)=eps;
%         E0(E0>=1)=1-eps;
%         
%         E1=C1(IDX1,:)*C1(IDX1,:)';
%         E1(E1<=0)=eps;
%         E1(E1>=1)=1-eps;
%         
%         
%         params.lnE0=log(E0);
%         params.lnE1=log(E1);
%         params.ln1E0=log(1-E0);
%         params.ln1E1=log(1-E1);
%         
%         
%         [Lhat Lsem yhat] = naive_bayes_classify(AA,constants.ys,params);
%         
%         icount=icount+1;
%         LhatN(icount,k)=Lhat.all;
%     end
% end
% 
% imagesc(LhatN(:,2:end)), colorbar


%%

clear LhatN
dims=1:40; %unique(round(logspace(0,log10(70),10)));
subspace.all=1:4900;
Lhata=nan(10);
Lhate=nan(10);
Lhatv=nan(10);
for k=2:10;
    icount=0;
    for i=dims(1:k)
        lat0 = estimate_latent_features_eig(A0, i);
        lat1 = estimate_latent_features_eig(A1, i);
                
        
        
        
        [U,~,R] = svd(lat1'*lat0);
        lat1 = lat1*R*U';
        
        lats = [lat0; lat1];
        
        T = clusterdata(lats,k);
        centroid=nan(k,i);
        for j=1:k
           centroid(j,:)=mean(lats(T==j,:),1); 
        end
        
        [IDX C] = kmeans(lats,k,'start',centroid);
        
        
        vset=find(IDX(1:70)~=IDX(71:140));
        
        E0=C(IDX(1:70),:)*C(IDX(1:70),:)';
        E0(E0<=0)=eps;
        E0(E0>=1)=1-eps;
        
        E1=C(IDX(71:end),:)*C(IDX(71:end),:)';
        E1(E1<=0)=eps;
        E1(E1>=1)=1-eps;
                
        params.lnE0=log(E0);
        params.lnE1=log(E1);
        params.ln1E0=log(1-E0);
        params.ln1E1=log(1-E1);
        
        blank=zeros(70);
        blank(vset,:)=1;
        blank(:,vset)=1;
        subspace.rdpge=find(blank);
        
        blank=zeros(70);
        blank(vset,vset)=1;
        subspace.rdpgv=find(blank);
        
        [Lhat Lsem yhat] = naive_bayes_classify(AA,constants.ys,params,subspace);
        
        icount=icount+1;
        Lhata(icount,k)=Lhat.all;
        Lhate(icount,k)=Lhat.rdpge;
        Lhatv(icount,k)=Lhat.rdpgv;
        
    end
end

figure(1), 
subplot(311),imagesc(Lhata(:,2:end)), colorbar
subplot(312),imagesc(Lhate(:,2:end)), colorbar
subplot(313),imagesc(Lhatv(:,2:end)), colorbar
