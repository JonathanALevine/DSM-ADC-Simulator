function [analog_out] = dac(digital_in)
    global VFS;
    n_bits = 8;
    % 8-Bit ADC means 2^8 = 256 levels
    VLSB = VFS/(2^(n_bits));
    analog_out = VLSB*bin2dec(digital_in);
end