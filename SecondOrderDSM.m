close all;  
clear; %intialization

set(0,'DefaultFigureWindowStyle','docked')

global VFS;
VFS = 2*(1);

% Simulation settings 
save_plots = 0;

sampling_rate = 200*1e6;
clock_frequency = sampling_rate;
clock_period = 1/clock_frequency;

OSR = sampling_rate / (2.5*1e6);

start_time = 0*clock_period;
end_time = 1000*clock_period;

clock_num_points = 1000000;
clock_times = linspace(start_time, end_time, clock_num_points);

input_sequence = myInputSequence(clock_times);
input_sequence = decimate(input_sequence, OSR);
clock_times = decimate(clock_times, OSR);
clock = myClock(clock_times, clock_frequency);

outputs = zeros(1, length(clock_times));
adc_samples = zeros(1, length(clock_times));

% ADC Block
hold_state = 0;
hold_val = adc_samples(1);
for i=2:length(clock_times)
    if clock(i) == 1 && hold_state == 0
        digitized_version = adc(input_sequence(i), 8);
        adc_samples(i) = dac(digitized_version);
        hold_val = adc_samples(i);
        hold_state = 1;
    end
    if clock(i) == 0
        adc_samples(i) = hold_val;
        hold_state = 0;
        hold_val = adc_samples(i);
    end
    if hold_state == 1
        adc_samples(i) = hold_val;
    end
end

% DSM ADC Block
% Initialize the reference voltage
% and the integrator previous val
vref = 0;
prev_val = 0;
prev_val_2 = 0;
hold_state = 0;
hold_val = outputs(1);
for i=2:length(clock_times)
    delta_val = difference_amp(input_sequence(i), vref);
    integrator_val = integrator(delta_val, prev_val);
    prev_val = integrator_val;
    
    delta_val = difference_amp(integrator_val, vref);
    integrator_val = integrator(delta_val, prev_val_2);
    prev_val_2 = integrator_val;

    digitized_val = adc(integrator_val, 2);
    

    vref = digitizer(digitized_val);

    outputs(i) = digitizer(digitized_val);
end

num_to_show = length(clock_times)/5;
figure(1)
subplot(3, 1, 1)
plot(clock_times(1:num_to_show)/1e-6, input_sequence(1:num_to_show))
xlabel('Time (\mus)')
ylabel('Input Signal (V)')

subplot(3, 1, 2)
plot(clock_times(1:num_to_show)/1e-6, clock(1:num_to_show))
xlabel('Time (\mu s)')
ylabel('Clock (V)') 

subplot(3, 1, 3)
stairs(outputs(1:num_to_show))
xlabel('Time (\mus)')
ylabel('DSM ADC (V)')

if save_plots
    FN2 = 'Figures/time_domains_second_order';   
    print(gcf, '-dpng', '-r600', FN2);  %Save graph in PNG
end

figure(2)
L = length(outputs);
Y = fft(outputs, L);
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = clock_frequency*(0:(L/2))/L;

semilogx(f,10*log10(P1)) 
title("Amplitude Spectrum of Sampled Signal")
xlabel("Frequency (Hz)")
ylabel("Signal Power (dB)")

% figure(3)
% L = length(outputs);
% Y = fft(outputs, L);
% P2 = abs(Y/L);
% P1 = P2(1:L/2+1);
% P1(2:end-1) = 2*P1(2:end-1);
% f = clock_frequency*(0:(L/2))/L;
% 
% plot(f, P1)
% title("Amplitude Spectrum of Sampled Signal")
% xlabel("Frequency (Hz)")
% ylabel("Signal Power (V)")

SNR = getSNR(P1)
SNR_Theoretical = 6.02*2 + 1.76 - -12.9 + 50*log10(OSR)
SFDR = getSFDR(P1)
SINAD = getSINAD(P1)
ENOB = getENOB(SINAD)

if save_plots
    FN2 = 'Figures/fft_second_order';   
    print(gcf, '-dpng', '-r600', FN2);  %Save graph in PNG
end