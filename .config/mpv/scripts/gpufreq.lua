function get_sys_value(variable)
    local f = assert(io.open(variable, "r"))
    local val = string.gsub(f:read("*all"), "\n", "")
    f:close()
    return val
end

function show_gpu_freq(card)
    local freq_cur = get_sys_value("/sys/class/drm/" .. card .. "/gt_act_freq_mhz")
    local freq_max = get_sys_value("/sys/class/drm/" .. card .. "/gt_max_freq_mhz")
    local freq_req = get_sys_value("/sys/class/drm/" .. card .. "/gt_cur_freq_mhz")
    mp.osd_message(freq_cur .. "/" .. freq_max .. " MHz (requested " .. freq_req .. " MHz)")
end

mp.register_script_message("show-gpu-freq", show_gpu_freq)
mp.add_key_binding("G", "show-gpu-freq", show_gpu_freq)
