#!/usr/bin/lua

--[[
    lua 使用uloop的服务器
]]

local socket = require 'socket'
local uloop = require 'uloop'

local host = "*"
local port = "12345"
local servers = {}
local clients = {}
local timer

uloop.init()

timer = uloop.timer(
    function()
        local i = 0
        for k,v in pairs(clients) do
            i = i + 1
        end
        print("have " .. i .. " clients")
        timer:set(1000)
    end, 1000
)
local s = socket.bind(host, port)
if s then
    local tcp_ev = uloop.fd_add(s,
                                function(ufd, events)
                                    local conn = ufd:accept()
                                    if conn then
                                        local peer,peerport = conn:getpeername()
                                        print("A client successful connected!" .. peer .. ":" .. peerport)
                                        local c_ev =
                                            uloop.fd_add(conn,
                                                         function(ufd, events)
                                                             local msg = ufd:receive()
                                                             if not msg then
                                                                 clients[ufd]:cancel()
                                                                 clients[ufd] = nil
                                                             else
                                                                 ufd:send(msg .. "\n")
                                                             end
                                                         end, uloop.ULOOP_READ)
                                        clients[conn] = c_ev
                                    end
                                end ,
                                uloop.ULOOP_READ)
    servers[s] = tcp_ev
end

uloop.run()
