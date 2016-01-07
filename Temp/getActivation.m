function [ainput, ahidden, aoutput] = getActivation(W1, W2, b1, b2, input)
 
ainput = input;
ahidden = bsxfun(@plus, W1 * ainput, b1);
ahidden = sigmoid(ahidden);
aoutput = bsxfun(@plus, W2 * ahidden, b2);
aoutput = sigmoid(aoutput);
end