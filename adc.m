function [digital_out] = adc(analog_in, n_bits)
    global VFS;
    digital_out = "";
    %n_bits = 8;
    VFS = 2*(1);
    % 8-Bit ADC means 2^8 = 256 levels
    for i=(n_bits-1):-1:0
        VLSB = 1*VFS/(2^(n_bits));
        check_val = VLSB*(2^i);
        if analog_in > check_val
            digital_out = digital_out + "1";
            analog_in = analog_in - check_val;
        else
            digital_out = digital_out + "0";
        end
    end
    return;
end