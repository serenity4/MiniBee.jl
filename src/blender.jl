# To be implemented in Blender with Python

function serve(port)
    @async begin
        server = listen(port)
        while true
            sock = accept(server)
            println("Connection request received. How may I aid you?")
            while isopen(sock)
                i = read(sock, UInt8)
                @info "Received $i"
            end
        end
    end
end

function look_for_port(; limit=typemax(UInt16))
    port = 1999
    while true && port + 1 < limit
        port += 1
        try
            res = serve(port)
            @info "Found available port $port"
            return port
        catch e
            e isa Sockets.IOError && continue
        end
    end
end

function trigger_blender(sock)
end