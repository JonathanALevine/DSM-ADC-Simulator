function [analog_val] = digitizer(digital_val)
    if digital_val == "00"
        analog_val = -2;
    elseif digital_val == "01"
        analog_val = -2/3;
    elseif digital_val == "10"
        analog_val = +2/3;
    else
        analog_val = 2;
    end
    return;
end