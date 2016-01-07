visibleSize = 144;
hiddenSize = 160;

sparsityParam = 0.01;
lambda = 0.0001;      
beta = 3;

theta = initializeParameters(hiddenSize, visibleSize);

[cost, grad] = sparseAutoencoderCost(theta, visibleSize, hiddenSize, lambda, ...
                                     sparsityParam, beta, patches);

theta = initializeParameters(hiddenSize, visibleSize);

options.HessUpate = 'lbfgs';

options.MaxIter = 400;
options.Display = 'iter';
options.GradObj = 'on';


[opttheta, cost] = fminlbfgs( @(p) sparseAutoencoderCost(p, ...
                                   visibleSize, hiddenSize, ...
                                   lambda, sparsityParam, ...
                                   beta, patches), ...
                              theta, options);
