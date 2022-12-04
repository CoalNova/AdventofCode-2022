const std = @import("std");
const aid = @import("../aidingfunctions.zig");
const day = @embedFile("../dayinputs/day03_input.txt");

pub fn solveDay(print_output: bool) void {
    var sack_group: [2][]u8 = [_][]u8{ undefined, undefined };
    sack_group[0] = aid.allocator.alloc(u8, 128) catch |err| return std.debug.print("{!}\n", .{err});
    sack_group[1] = aid.allocator.alloc(u8, 128) catch |err| return std.debug.print("{!}\n", .{err});
    var group_size: [2]usize = [_]usize{ 0, 0 };

    var part_one_sum: u32 = 0;
    var part_two_sum: u32 = 0;

    var sack_step: usize = 0;

    var sacks = std.mem.split(u8, day, "\n");
    while (sacks.next()) |sack| {

        //part one comparison of first and second halves of a sack
        comparison: for (sack[0..(sack.len >> 1)]) |s1|
            for (sack[(sack.len >> 1)..sack.len]) |s2|
                if (s1 == s2) {
                    part_one_sum += if (s1 > 96) s1 - 96 else s1 - 38;
                    break :comparison;
                };

        //increment sack step count
        if (sack_step > 1) {
            sack_step = 0;
            group_comparison: for (sack_group[0][0..group_size[0]]) |s1|
                for (sack_group[1][0..group_size[1]]) |s2|
                    if (s1 == s2)
                        for (sack) |s3|
                            if (s2 == s3) {
                                part_two_sum += if (s1 > 96) s1 - 96 else s1 - 38;
                                break :group_comparison;
                            };
        } else {
            //add sack to group
            for (sack) |s, i| sack_group[sack_step][i] = s;
            group_size[sack_step] = sack.len;
            sack_step += 1;
        }
    }
    //_now_ free sacks
    aid.allocator.free(sack_group[0]);
    aid.allocator.free(sack_group[1]);

    if (print_output)
        aid.printResult(3, part_one_sum, part_two_sum) catch |err| return std.debug.print("{!}\n", .{err});
}
