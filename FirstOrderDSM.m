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

start_time = 0*clock_period;
end_time = 100*clock_period;

clock_num_points = 1000;
clock_times = linspace(start_time, end_time, clock_num_points);

input_sequence = myInputSequence(clock_times);
clock = myClock(clock_times, clock_frequency);

outputs = zeros(1, length(clock_times));
adc_samples = zeros(1, length(clock_times));

% ADC Block
hold_state = 0;
hold_val = adc_samples(1);
for i=2:length(clock_times)
    if clock(i) == 1 && hold_state == 0
        digitized_version = adc(input_sequence(i));
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
vref = 0;
prev_val = 0;

hold_state = 0;
hold_val = outputs(i);
for i=2:length(clock_times)
    delta_val = difference_amp(input_sequence(i), vref);
    integrator_val = integrator(delta_val, prev_val);
    digitized_val = comparator(integrator_val);
    prev_val = integrator_val;
    vref = digitizer(digitized_val);
    outputs(i) = digitizer(digitized_val);
    hold_val = outputs(i);
    hold_state = 1;
end

mean(outputs)
mean(adc_samples)

figure(1)
subplot(4, 1, 1)
plot(clock_times/1e-6, input_sequence)
xlabel('Time (\mus)')
ylabel('Input Signal (V)')

subplot(4, 1, 2)
plot(clock_times/1e-6, clock)
xlabel('Time (\mu s)')
ylabel('Clock (V)') 

subplot(4, 1, 3)
plot(clock_times/1e-6, adc_samples)
xlabel('Time (\mus)')
ylabel('8-Bit ADC (V)') 

subplot(4, 1, 4)
% plot(clock_times(1:100)/1e-6, outputs(1:100))
stairs(outputs(1:1000))
xlabel('Time (\mus)')
ylabel('DSM ADC (V)') 

% if save_plots
%     FN2 = 'Figures/time_domains_non_linear_adc';   
%     print(gcf, '-dpng', '-r600', FN2);  %Save graph in PNG
% end

% figure(2)
% L = 8192;
% Y = fft(samples, L);
% P2 = abs(Y/L);
% P1 = P2(1:L/2+1);
% P1(2:end-1) = 2*P1(2:end-1);
% f = clock_frequency*(0:(L/2))/L;
% 
% stem(f(1:100)/1e5,(P1(1:100))) 
% title("Amplitude Spectrum of Sampled Signal")
% xlabel("Frequency (MHz)")
% ylabel("Signal Power (V)")
% 
% SNR = getSNR(P1)
% % ideal_SNR = 6.02*8-1.76
% SFDR = getSFDR(P1)
% SINAD = getSINAD(P1)
% ENOB = getENOB(SINAD)

% if save_plots
%     FN2 = 'Figures/fft_partA';   
%     print(gcf, '-dpng', '-r600', FN2);  %Save graph in PNG
% end