local llthreads = require"llthreads"

local thread_code = [[
	-- print thread's parameter.
	print("CHILD: received params:", ...)
	-- return all thread's parameters back to the parent thread.
	return ...
    ]]

-- create detached child thread.
--local thread = llthreads.new(thread_code, "number:", 1234, "nil:", nil, "bool:", true)
-- start non-joinable detached child thread.
--assert(thread:start(true))
-- Use a detatched child thread when you don't care when the child finishes.

-- create child thread.
--local thread = llthreads.new(thread_code, "number:", 1234, "nil:", nil, "bool:", true)
-- start joinable child thread.
--assert(thread:start())
-- Warning: If you don't call thread:join() on a joinable child thread, it will be called
-- by the garbage collector, which may cause random pauses/freeze of the parent thread.
--print("PARENT: child returned: ", thread:join())

--local socket = require"socket"
--socket.sleep(2) -- give detached thread some time to run.

local socket = require "socket"

local thread_code1 = [[
    local socket = require "socket"
    local c = assert(socket.connect("10.0.2.203", 12345))
    while true do
        c:send("hello,server\n")
        local msg = c:receive()
        if msg then
            print("recv from server " .. msg)
        end
        socket.sleep(1)
    end
    c:close()
    ]]
local threads = {}
local threads_count = 1
for var=1,100,1 do
    local thread = llthreads.new(thread_code1, "num:", var)
    threads[threads_count] = thread
    threads_count = threads_count + 1
    thread:start()
end

for var=1,1,1 do
    threads[var]:join()
end
