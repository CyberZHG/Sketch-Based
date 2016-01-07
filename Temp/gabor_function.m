function Response = gabor_function(X, Y, Lambda, Theta, Psi, Sigma, Gamma)
% Lambda: the wavelength of the sinusoidal factor.
% Theta: the orientation of the normal to the parallel stripes.
% Psi: the phase offset.
% Sigma:  the standard deviation of the Gaussian envelope.
% Gamma: the spatial aspect ratio.
XX = X * cos(Theta) + Y * sin(Theta);
YY = -X * sin(Theta) + Y * cos(Theta);
Gaussian = exp(- (XX.^2 + Gamma^2 * YY.^2) / (2 * Sigma^2));
Sinusoid = cos(2 * pi * XX / Lambda + Psi);
Response = Gaussian .* Sinusoid;
