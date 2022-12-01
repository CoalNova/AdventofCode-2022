const std = @import("std");
const aid = @import("../aidingfunctions.zig");
const x01 = @embedFile("../dayinputs/day01_input.txt");

pub fn solveDay() void
{
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    var calories : []i32 = undefined;
    defer allocator.free(calories);

    calories = aid.parseNumberList(x01, allocator) catch |err| return std.debug.print("Day one error: {!}", .{err});

    var sum : u32 = 0;
    var max : u32 = 0;
    var gre : [3]u32 = [_]u32{0,0,0};
    for(calories) |c|
    {
        if (c < 1)
        {
            for(gre) |g, i|
            {
                if (sum > g)
                {
                    gre[i] = sum;
                    break;
                }
            }
            max = if (sum > max) sum else max;
            sum = 0;
        }
        else
            sum += @intCast(u32, c);
    
    }
    aid.printResult(1, max , gre[0] + gre[1] + gre[2]) catch |err| return std.debug.print("{!}", .{err});
}