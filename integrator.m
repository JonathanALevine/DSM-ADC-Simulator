function [val] = integrator(delta_val, prev_val)
    val = delta_val + prev_val;
    return;
end