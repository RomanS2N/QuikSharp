--~ Copyright Ⓒ 2014 Victor Baybekov

-- is running from Quik
function is_quik()
    if getScriptPath then return true else return false end
end
if is_quik() then
    package.path = package.path .. ";" .. getScriptPath() .. "\\?.lua;" .. getScriptPath() .. "\\?.luac"
    package.cpath = package.cpath .. ";" .. getScriptPath() .. '\\clibs\\?.dll'
else
    package.path = package.path .. ";" .. ".\\?.lua;" .. ".\\?.luac"
    package.cpath = package.cpath .. ";" .. '.\\clibs\\?.dll'
end
local util = require("qsutils")
local qf = require("qsfunctions")
require("qscallbacks")

local is_started = true

function do_main()
    log("Entered main function")
    while is_started do
        -- if not connected, connect
        util.connect()
        -- when connected, process queue
        -- receive message,
        local requestMsg = receiveRequest()
        if requestMsg then
            -- if ok, process message
            -- dispatch_and_process never throws, it returns lua errors wrapped as a message
            local responseMsg, err = qf.dispatch_and_process(requestMsg)
            if responseMsg then
                -- send message
                local res = sendResponse(responseMsg)
            else
                log("Could not dispatch and process request: " .. err, 3)
            end
        else
            delay(1)
        end
    end
end

function main()
    local status, err = pcall(do_main)
    if status then
        log("finished")
    else
        log(err, 3)
    end
end

if not is_quik() then
    log("Hello, QuikSharp! Running outside Quik.")
    do_main()
    logfile:close()
end

