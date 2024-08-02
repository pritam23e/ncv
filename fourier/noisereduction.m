%Noise Processing by fourier transform
close all
clear all

N=500; 
% Define the time vector
t = linspace(0, 10, N);

% Define the true sine wave function
y_true = cos(t).*sin(t+8);

% Add noise
noise_amplitude = 0.5; % Adjust the noise level as needed
noise = noise_amplitude * randn(size(t)); % Gaussian noise
ft= y_true + noise;

w0=2*pi/N;
w=linspace(w0,2*pi,N);
fw=zeros(1,N);
fwo=0;
fxo=0;

%filters
pass_low=50; 
pass_high=300; 

for n=1:N
  for k=1:N
    fwo=fwo+ft(k)*exp(-i*w0*n*k);
  end
  fw(n)=fwo;
  fwo=0; 
end

%Filter 
for n=1:N
    if fw(n) > pass_low && fw(n) < pass_high
        Fw(n)=fw(n);
    else
        Fw(n)=0;
    end
end

%inverse fourier transform 
for n=1:N
  for k=1:N
    fxo=fxo+Fw(k)*exp(i*w0*n*k);
  end
  fx(n)=fxo/N;
  fxo=0; 
end

subplot(4,1,1)
plot(t,ft)
title("Original function ")

subplot(4,1,2)
plot(w,abs(fw))
title("Fourier transform")

subplot(4,1,3)
plot(w,abs(Fw))
title("Pass Filter")

subplot(4,1,4)
plot(t,fx)
title("Filtered inverse fourier transform")
