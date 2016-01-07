function opttheta = sparse_auto_encoder(patches, visibleSize, hiddenSize, theta)
    sparsityParam = 0.01;
    lambda = 0.0001;      
    beta = 1;
    if nargin < 4
        theta = initializeParameters(hiddenSize, visibleSize);
    end
    %patches = patches' / (max(max(patches)) + 1e-8) * 0.8 + 0.1;
    patches = patches';
    
    options.HessUpate = 'lbfgs';
    options.MaxIter = 100;
    options.Display = 'iter';
    options.GradObj = 'on';
    
    step = 0.05;
    last_err = 1e100;
    cnt = 0;
    for i = 1 : options.MaxIter
        [~, d] = sparseAutoencoderCost(theta, ...
                               visibleSize, hiddenSize, ...
                               lambda, sparsityParam, ...
                               beta, patches);
        theta = theta - d * step;
    W1 = reshape(theta(1:hiddenSize*visibleSize), hiddenSize, visibleSize);
    W2 = reshape(theta(hiddenSize*visibleSize+1:2*hiddenSize*visibleSize), visibleSize, hiddenSize);
    b1 = theta(2*hiddenSize*visibleSize+1:2*hiddenSize*visibleSize+hiddenSize);
    b2 = theta(2*hiddenSize*visibleSize+hiddenSize+1:end);
        [~, ~, output] = getActivation(W1, W2, b1, b2, patches);
        errtp = ((output - patches) .^ 2) ./ 2;
        err = sum(sum(errtp)) ./ size(patches, 2);
        if err > last_err + 1e-6
            cnt = cnt + 1;
            if cnt > 5
                cnt = 0;
                step = step * 0.5;
                if step < 1e-4
                    break
                end
            end
        end
        last_err = err;
        display(sprintf('%5.0f %13.6g %13.7g', i, step, err));
    end
    opttheta = theta;

 %   [opttheta, cost] = fminlbfgs(@(p) sparseAutoencoderCost(p, ...
  %                                     visibleSize, hiddenSize, ...
  %                                     lambda, sparsityParam, ...
  %                                     beta, patches), ...
  %                                 theta, options);
                               
%     W1 = reshape(opttheta(1:hiddenSize*visibleSize), hiddenSize, visibleSize);
%     W2 = reshape(opttheta(hiddenSize*visibleSize+1:2*hiddenSize*visibleSize), visibleSize, hiddenSize);
%     b1 = opttheta(2*hiddenSize*visibleSize+1:2*hiddenSize*visibleSize+hiddenSize);
%     b2 = opttheta(2*hiddenSize*visibleSize+hiddenSize+1:end);
%     
%     [~, ~, output] = getActivation(W1, W2, b1, b2, patches);
%     display_network(output(:, 1:784)', 12); 
end