_G.logit = {}

function logit.log(prefix, message)
    local time = os.epoch("local") / 1000
    local time_table = os.date("*t", time)
    local strtime = time_table.hour .. ":" .. time_table.min .. ":" .. time_table.sec
    print("INFO [" .. strtime .. "] [" .. prefix .. "] " .. message)
end