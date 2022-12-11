const std = @import("std");
const aid = @import("../aidingfunctions.zig");
const day = @embedFile("../dayinputs/day02_input.txt");

const hand_lut = [_]u32{
    3 + 1, //0b00_00
    6 + 2, //0b00_01
    0 + 3, //0b00_10
    0, //0b00_11 unused
    0 + 1, //0b01_00
    3 + 2, //0b01_01
    6 + 3, //0b01_10
    0, //0b01_11 unused
    6 + 1, //0b10_00
    0 + 2, //0b10_01
    3 + 3, //0b10_10
};

const outcome_lut = [_]u32{
    0 + 3, //0b00_00
    3 + 1, //0b00_01
    6 + 2, //0b00_10
    0, //0b00_11 unused
    0 + 1, //0b01_00
    3 + 2, //0b01_01
    6 + 3, //0b01_10
    0, //0b01_11 unused
    0 + 2, //0b10_00
    3 + 3, //0b10_01
    6 + 1, //0b10_10
};

pub fn solveDay(print_output: bool) void {
    
    var part_one_score: u32 = 0;
    var part_two_score: u32 = 0;

    @setEvalBranchQuota(day.len * 10);

    comptime inline for(day) |char, index| {
        if ((index & 3) == 0) 
            part_one_score += hand_lut[@intCast(usize, ((char - 65) << 2) + (day[index + 2] - 88))];
    };

    comptime inline for(day) |char, index| 
    {
        if ((index & 3) == 0) 
            part_two_score += outcome_lut[@intCast(usize, ((char - 65) << 2) + (day[index + 2] - 88))];
    };

    if (print_output)
        aid.printResult(2, part_one_score, part_two_score) catch |err| return std.debug.print("{!}\n", .{err});
}
