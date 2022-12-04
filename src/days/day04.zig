const std = @import("std");
const aid = @import("../aidingfunctions.zig");
const day = @embedFile("../dayinputs/day04_input.txt");

pub fn solveDay(print_output: bool) void {
    var overlaps_part_one: u32 = 0;
    var overlaps_part_two: u32 = 0;

    var ranges: [4]i32 = [_]i32{ 0, 0, 0, 0 };
    var range_indexer: usize = 0;

    var pairs = std.mem.split(u8, day, "\n");
    while (pairs.next()) |line| {
        if (line.len > 3) {
            range_indexer = 0;
            ranges = [_]i32{ 0, 0, 0, 0 };
            for (line) |char| {
                if (char >= 48 and char < 58) {
                    ranges[range_indexer] = ranges[range_indexer] * 10 + char - 48;
                } else range_indexer += 1;
            }
            if ((ranges[0] >= ranges[2]) == (ranges[1] <= ranges[3]) or (ranges[0] <= ranges[2]) == (ranges[1] >= ranges[3]))
                overlaps_part_one += 1;
            if ((ranges[0] >= ranges[2] and ranges[0] <= ranges[3]) or (ranges[1] >= ranges[2] and ranges[1] <= ranges[3]) or (ranges[2] >= ranges[0] and ranges[2] <= ranges[1]) or (ranges[3] >= ranges[0] and ranges[3] <= ranges[1]))
                overlaps_part_two += 1;
        }
    }
    if (print_output)
        aid.printResult(4, overlaps_part_one, overlaps_part_two) catch |err| return std.debug.print("{!}\n", .{err});
}
