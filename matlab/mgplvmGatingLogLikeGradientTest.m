function [gX] = mgplvmGatingLogLikeGradientTest(model,gX)

% MGPLVMCOMPUTEGATING Compute the gates of a MGPLVM model.
% FORMAT
% 
%
% COPYRIGHT : Neil D. Lawrence and Raquel Urtasun, 2007
%
% SEEALSO : modelCreate, mgplvmOptions

% MGPLVM


%%%%%%%%%%%%%%%%%%%%%%%% first gating
% for m=1:model.M
% % if optimise the gating
%     if model.optimiseGating        
%         
%         % do only for the active ones, the other are zero, since multiply
%         % by <snm>
%         dpim_dX = zeros(model.N,model.q);
%         dpim_dX = repmat(model.centres(m,:),model.N,1);
%         for kk =1:model.M
%             dpim_dX = dpim_dX - repmat(model.centres(kk,:),model.N,1).*repmat(model.pi(:,kk),1,model.q);
%         end
%         gX = gX + model.d*(repmat(model.expectation.s(:,m),1,model.q).*dpim_dX);
%     end
% end

%%%%%%%%%%%%%%%%%%%%%%%%%% just a constant
% gX = gX;


%%%%%%%%%%%%%%%%%%%%%%%%%% just a distance
% for m=1:model.M
%     to_add = model.d.*(model.X - repmat(model.centres(m,:),model.N,1))./repmat(model.pi(:,m),1,model.q);
%     gX = gX + to_add.*repmat(model.expectation.s(:,m),1,model.q);
% end

%%%%%%%%%%%%%%%%%%%%%%%%% non-normalized exponential
% for m=1:model.M
%     to_add = model.d*(repmat(model.centres(m,:),model.N,1)-model.X);
%     gX = gX + to_add.*repmat(model.expectation.s(:,m),1,model.q);
% end


%%%%%%%%%%%%%%%%%%%%%%%%% normalized exponential
% for m=1:model.M
%     to_add = (repmat(model.centres(m,:),model.N,1)-model.X);
%     gX = gX + model.d*to_add.*repmat(model.expectation.s(:,m),1,model.q);
%     to_add2 = zeros(model.N,model.q);
%     for kk = 1:model.M
%         to_add2 = to_add2 + repmat(model.pi(:,kk),1,model.q).*(repmat(model.centres(kk,:),model.N,1)-model.X);
%     end 
%     gX = gX - model.d*to_add2.*repmat(model.expectation.s(:,m),1,model.q);  
% end


% good_acum = zeros(model.N,model.q);
% to_compare = zeros(model.N,model.q);
% to_compare_other = zeros(model.N,model.q);
% see where the error in the math is
for m=1:model.M
%     to_add = (repmat(model.centres(m,:),model.N,1)-model.X);
%     to_add_other = repmat(model.centres(m,:),model.N,1);
%     to_add2 = zeros(model.N,model.q);
%     to_add2_other = zeros(model.N,model.q);
%     
%     to_add2_other_other = zeros(model.N,model.q);
%     for kk = 1:model.M
%         to_add2 = to_add2 + repmat(model.pi(:,kk),1,model.q).*(repmat(model.centres(kk,:),model.N,1)-model.X);
%         to_add2_other = to_add2_other + repmat(model.centres(kk,:),model.N,1).*repmat(model.pi(:,kk),1,model.q);
% %         to_compare = to_compare + model.d*repmat(model.expectation.s(:,m)-model.pi(:,m),1,model.q).*repmat(model.centres(m,:),model.N,1);   
% %         to_compare_other = to_compare_other+ model.d*repmat(model.expectation.s(model.activePoints(:,m),m)-model.pi(model.activePoints(:,m),m),1,model.q).*repmat(model.centres(m,:),size(find(model.activePoints(:,m)),1),1);
% %     
%         to_add2_other_other = to_add2_other_other + repmat(model.expectation.s(:,kk),1,model.q);
% 
%     end
    
%     good = -model.d*to_add2.*repmat(model.expectation.s(:,m),1,model.q) + model.d*to_add.*repmat(model.expectation.s(:,m),1,model.q);
%     
%     good_other = -model.d*to_add2_other.*repmat(model.expectation.s(:,m),1,model.q) + model.d*to_add_other.*repmat(model.expectation.s(:,m),1,model.q);
%     
%     diff_prob = model.expectation.s(:,m) - model.pi(:,m);
%     to_compare = to_compare + model.d*(repmat(diff_prob,1,model.q).*repmat(model.centres(m,:),model.N,1));
    
%     to_compare_other = to_compare_other + model.d*repmat(model.centres(m,:),model.N,1).*repmat(model.pi(:,m),1,model.q);%.*to_add2_other_other;
%     to_compare_other = to_compare_other +
%     model.d*repmat(model.expectation.s(:,m),1,model.q).*repmat(model.centres(m,:),model.N,1);
    gX = gX+ model.d*repmat(model.centres(m,:),model.N,1).*(repmat(model.expectation.s(:,m),1,model.q) - repmat(model.pi(:,m),1,model.q));
    
%     good_acum = good_acum + good;
%     to_compare = model.d*repmat(model.expectation.s(:,m)-model.pi(:,m),1,model.q).*repmat(model.centres(m,:),model.N,1);
%     
%     to_compare - good
%     
%     
%     to_compare = model.d*repmat(model.expectation.s(model.activePoints(:,m),m)-model.pi(model.activePoints(:,m),m),1,model.q).*repmat(model.centres(m,:),size(find(model.activePoints(:,m)),1),1);
%     
%     to_compare - good(model.activePoints(:,m),:)
    
end

% gX = gX + to_compare_other;

% compare here
