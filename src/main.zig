const std = @import("std");
const aid = @import("./aidingfunctions.zig");
const d01 = @import("./days/day01.zig");
const d02 = @import("./days/day02.zig");
const d03 = @import("./days/day03.zig");
const d04 = @import("./days/day04.zig");
const d05 = @import("./days/day05.zig");
const d06 = @import("./days/day06.zig");
const d08 = @import("./days/day08.zig");

pub fn main() !void {
    var args: [][]u8 = try std.process.argsAlloc(aid.allocator);
    defer aid.allocator.free(args);

    d01.solveDay(true);
    d02.solveDay(true);
    d03.solveDay(true);
    d04.solveDay(true);
    d05.solveDay(true);
    d06.solveDay(true);
    d08.solveDay(true);

    if (args.len > 1) {
        var test_times: u32 = 0;
        for (args[1]) |v| {
            if (@intCast(u32, v - 48) < 10)
                test_times += test_times * 9 + (v - 48);
        }

        aid.benchmarkDay(1, &d01.solveDay, test_times);
        aid.benchmarkDay(2, &d02.solveDay, test_times);
        aid.benchmarkDay(3, &d03.solveDay, test_times);
        aid.benchmarkDay(4, &d04.solveDay, test_times);
        aid.benchmarkDay(5, &d05.solveDay, test_times);
        aid.benchmarkDay(6, &d06.solveDay, test_times);
        aid.benchmarkDay(8, &d08.solveDay, test_times);
    }
}
