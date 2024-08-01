close all
clear all
N=500; 
% Define the time vector
t = linspace(0,10, N);

% Define the true sine wave function
y_true = sin(t);

% Add noise
noise_amplitude = 0.5; % Adjust the noise level as needed
noise = noise_amplitude * randn(size(t)); % Gaussian noise
ft= y_true + noise;




w0=2*pi/N;
w=linspace(w0,2*pi,N);


fw=zeros(1,N);
fwo=0;
fxo=0;


for n=1:N
  for k=1:N
    fwo=fwo+ft(k)*exp(-i*w0*n*k);
  end
  fw(n)=fwo;
  fwo=0;
  
  
end

for n=1:N
  for k=1:N
    fxo=fxo+fw(k)*exp(i*w0*n*k);
  end
  fx(n)=fxo/(N);
  fxo=0;
  
  
end




subplot(3,1,1)
plot(t,ft)
title("function ")

subplot(3,1,2)
plot(w,abs(fw))
title("fourier transform")

subplot(3,1,3)
plot(t,fx)
title("inverse fourier transform")
