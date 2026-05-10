const std = @import("std");
const Request = @import("request.zig");
const Response = @import("response.zig");
const Server = @import("server.zig").Server;
const Method = @import("request.zig").Method;

pub fn main(init: std.process.Init) !void {
    const io = init.io;
    const server = try Server.init(io);
    var listening = try server.listen();
    const connection = try listening.accept(io);
    defer connection.close(io);

    var request_buffer: [1000]u8 = undefined;
    @memset(request_buffer[0..], 0);
    try Request.read_request(io, connection, request_buffer[0..]);

    const request = try Request.parse_request(request_buffer[0..]);
    if (request.method == Method.GET) {
        try Response.send_200(connection, io);
    } else {
        try Response.send_404(connection, io);
    }
    std.debug.print("{s}\n", .{request_buffer});
}
