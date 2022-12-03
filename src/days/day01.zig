const std = @import("std");
const aid = @import("../aidingfunctions.zig");

pub fn solveDay(print_output: bool) void {
    var inputs = aid.loadFile("./dayinputs/day01_input.txt") catch |err| return std.debug.print("{!}\n", .{err});
    defer aid.allocator.free(inputs);

    var calories = aid.parseNumberList(inputs) catch |err| return std.debug.print("{!}\n", .{err});
    defer aid.allocator.free(calories);

    var sum: u32 = 0;
    var max: u32 = 0;
    var gre: [3]u32 = [_]u32{ 0, 0, 0 };
    for (calories) |c| {
        if (c < 1) {
            for (gre) |g, i|
                if (sum > g) {
                    gre[i] = sum;
                    break;
                };

            max = if (sum > max) sum else max;
            sum = 0;
        } else sum += @intCast(u32, c);
    }
    if (print_output)
        aid.printResult(1, max, gre[0] + gre[1] + gre[2]) catch |err| return std.debug.print("{!}", .{err});
}
