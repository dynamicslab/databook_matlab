function coef = optimal_SVHT_coef(beta, sigma_known)

% function omega = optimal_SVHT_coef(beta, sigma_known)
%
% Coefficient determining optimal location of Hard Threshold for Matrix
% Denoising by Singular Values Hard Thresholding when noise level is known or
% unknown.  
%
% See D. L. Donoho and M. Gavish, "The Optimal Hard Threshold for Singular
% Values is 4/sqrt(3)", http://arxiv.org/abs/1305.5870
%
% IN: 
%    beta: aspect ratio m/n of the matrix to be denoised, 0<beta<=1. 
%          beta may be a vector 
%    sigma_known: 1 if noise level known, 0 if unknown
% 
% OUT: 
%    coef:   optimal location of hard threshold, up the median data singular
%            value (sigma unknown) or up to sigma*sqrt(n) (sigma known); 
%            a vector of the same dimension as beta, where coef(i) is the 
%            coefficient correcponding to beta(i)
%
% Usage in known noise level:
%
%   Given an m-by-n matrix Y known to be low rank and observed in white noise 
%   with mean zero and known variance sigma^2, form a denoised matrix Xhat by:
%
%   [U D V] = svd(Y);
%   y = diag(Y);
%   y( y < (optimal_SVHT_coef(m/n,1) * sqrt(n) * sigma) ) = 0;
%   Xhat = U * diag(y) * V';
% 
%
% Usage in unknown noise level:
%
%   Given an m-by-n matrix Y known to be low rank and observed in white
%   noise with mean zero and unknown variance, form a denoised matrix 
%   Xhat by:
%  
%   [U D V] = svd(Y); 
%   y = diag(Y); 
%   y( y < (optimal_SVHT_coef_sigma_unknown(m/n,0) * median(y)) ) = 0; 
%   Xhat = U * diag(y) * V';
% 
% -----------------------------------------------------------------------------
% Authors: Matan Gavish and David Donoho <lastname>@stanford.edu, 2013
% 
% This program is free software: you can redistribute it and/or modify it under
% the terms of the GNU General Public License as published by the Free Software
% Foundation, either version 3 of the License, or (at your option) any later
% version.
%
% This program is distributed in the hope that it will be useful, but WITHOUT
% ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
% FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
% details.
%
% You should have received a copy of the GNU General Public License along with
% this program.  If not, see <http://www.gnu.org/licenses/>.
% -----------------------------------------------------------------------------


    if sigma_known
        coef = optimal_SVHT_coef_sigma_known(beta);
    else
        coef = optimal_SVHT_coef_sigma_unknown(beta);
    end    
end

function lambda_star = optimal_SVHT_coef_sigma_known(beta)
    assert(all(beta>0));
    assert(all(beta<=1));
    assert(prod(size(beta)) == length(beta)); % beta must be a vector
    
    w = (8 * beta) ./ (beta + 1 + sqrt(beta.^2 + 14 * beta +1)); 
    lambda_star = sqrt(2 * (beta + 1) + w);
end

function omega = optimal_SVHT_coef_sigma_unknown(beta)
    warning('off','MATLAB:quadl:MinStepSize')
    assert(all(beta>0));
    assert(all(beta<=1));
    assert(prod(size(beta)) == length(beta)); % beta must be a vector
    
    coef = optimal_SVHT_coef_sigma_known(beta);

    MPmedian = zeros(size(beta));
    for i=1:length(beta)
        MPmedian(i) = MedianMarcenkoPastur(beta(i));
    end

    omega = coef ./ sqrt(MPmedian);
end


function I = MarcenkoPasturIntegral(x,beta)
    if beta <= 0 | beta > 1,
        error('beta beyond')
    end
    lobnd = (1 - sqrt(beta))^2;
    hibnd = (1 + sqrt(beta))^2;
    if (x < lobnd) | (x > hibnd),
        error('x beyond')
    end
    dens = @(t) sqrt((hibnd-t).*(t-lobnd))./(2*pi*beta.*t);
    I = quadl(dens,lobnd,x);
    fprintf('x=%.3f,beta=%.3f,I=%.3f\n',x,beta,I);
end


function med = MedianMarcenkoPastur(beta)
    MarPas = @(x) 1-incMarPas(x,beta,0);
    lobnd = (1 - sqrt(beta))^2;
    hibnd = (1 + sqrt(beta))^2;
    change = 1;
    while change & (hibnd - lobnd > .001),
      change = 0;
      x = linspace(lobnd,hibnd,5);
      for i=1:length(x),
          y(i) = MarPas(x(i));
      end
      if any(y < 0.5),
         lobnd = max(x(y < 0.5));
         change = 1;
      end
      if any(y > 0.5),
         hibnd = min(x(y > 0.5));
         change = 1;
      end
    end
    med = (hibnd+lobnd)./2;
end

function I = incMarPas(x0,beta,gamma)
    if beta > 1,
        error('betaBeyond');
    end
    topSpec = (1 + sqrt(beta))^2;
    botSpec = (1 - sqrt(beta))^2;
    MarPas = @(x) IfElse((topSpec-x).*(x-botSpec) >0, ...
                         sqrt((topSpec-x).*(x-botSpec))./(beta.* x)./(2 .* pi), ...
                         0);
    if gamma ~= 0,
       fun = @(x) (x.^gamma .* MarPas(x));
    else
       fun = @(x) MarPas(x);
    end
    I = quadl(fun,x0,topSpec);
    
    function y=IfElse(Q,point,counterPoint)
        y = point;
        if any(~Q),
            if length(counterPoint) == 1,
                counterPoint = ones(size(Q)).*counterPoint;
            end
            y(~Q) = counterPoint(~Q);
        end
        
    end
end

