const std = @import("std");
const Stream = std.Io.net.Stream;

pub fn send_200(conn: Stream, io: std.Io) !void {
    // const message = ("HTTP/1.1 200 OK\nContent-Length: 48" ++ "\nContent-Type: text/html\n" ++ "Connection: Closed\n\n<html><body>" ++ "<h1>Hi you Idiot</h1></body></html>");
    const body =
        "<html><head><style>" ++
        "body { display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; background:#000000;  }" ++
        ".box { border: 2px solid lime; padding: 40px; text-align: center; color: lime; font-family: monospace;  }" ++
        "</style></head><body>" ++
        "<div class='box'><h1>Hi you Idiot</h1></div>" ++
        "</body></html>";

    const header = std.fmt.comptimePrint("HTTP/1.1 200 OK\r\nContent-Type: text/html\r\nContent-Length: {d}\r\nConnection: close\r\n\r\n", .{body.len});

    const message = header ++ body;
    var stream_writer = conn.writer(io, &.{});
    _ = try stream_writer.interface.write(message);
}

pub fn send_404(conn: Stream, io: std.Io) !void {
    const message = ("HTTP/1.1 404 Not Found\nContent-Length: 50" ++ "\nContent-Type: text/html\n" ++ "Connection: Closed\n\n<html><body>" ++ "<h1>File not found!</h1></body></html>");
    var stream_writer = conn.writer(io, &.{});
    _ = try stream_writer.interface.write(message);
}
