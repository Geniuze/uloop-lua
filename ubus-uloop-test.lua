#!/usr/bin/lua

local uloop = require 'uloop'
local ubus = require 'ubus'

uloop.init()

local conn = ubus.connect()
if not conn then
	error("Failed to connect to ubus")
end

local timer
timer = uloop.timer(
    function()
        print("in timer!")
        timer:set(1000)
    end, 1000
)

local method = {
    test = {
        hello = {
            function(req, msg)
                print("Call to hello")
                for k,v in pairs(msg) do
                    print(k,v)
                end
                conn:reply(req, {response="success"})
            end, {id = ubus.INT32, msg = ubus.STRING}

        }
    }
}

conn:add(method)

uloop.run()
