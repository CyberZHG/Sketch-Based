function Filter = gabor_filter(Size, Lambda, Theta, Psi, Sigma, Gamma)
% Lambda: the wavelength of the sinusoidal factor.
% Theta: the orientation of the normal to the parallel stripes.
% Psi: the phase offset.
% Sigma:  the standard deviation of the Gaussian envelope.
% Gamma: the spatial aspect ratio.
SigmaX = Sigma;
SigmaY = Sigma / Gamma;

MaxX = max(abs(Size * SigmaX * cos(Theta)), abs(Size * SigmaY * sin(Theta)));
MaxX = max(1, ceil(MaxX));
MaxY = max(abs(Size * SigmaX * sin(Theta)), abs(Size * SigmaY * cos(Theta)));
MaxY = max(1, ceil(MaxY));
MinX = -MaxX;
MinY = -MaxY;
[X, Y] = meshgrid(MinX:MaxX, MinY:MaxY);
Filter = gabor_function(X, Y, Lambda, Theta, Psi, Sigma, Gamma);
