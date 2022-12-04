const std = @import("std");
const aid = @import("../aidingfunctions.zig");
const day = @embedFile("../dayinputs/day01_input.txt");

pub fn solveDay(print_output: bool) void {
    var calories: u32 = 0;
    var sum: u32 = 0;
    var max: u32 = 0;
    var greatest: [3]u32 = [_]u32{ 0, 0, 0 };

    var raw_calories = std.mem.split(u8, day, "\n");

    while (raw_calories.next()) |raw| {
        calories = 0;
        for (raw) |char| calories = calories * 10 + (char - 48);
        if (calories < 1) {
            for (greatest) |g, i|
                if (sum > g) {
                    greatest[i] = sum;
                    break;
                };

            max = if (sum > max) sum else max;
            sum = 0;
        } else sum += calories;
    }
    if (print_output)
        aid.printResult(1, max, greatest[0] + greatest[1] + greatest[2]) catch |err| return std.debug.print("{!}", .{err});
}
