const std = @import("std");
const aid = @import("../aidingfunctions.zig");

pub fn solveDay(print_output: bool) void {
    var contents = aid.loadFile("./dayinputs/day03_input.txt") catch |err| return std.debug.print("{!}\n", .{err});
    defer aid.allocator.free(contents);

    var sack: []u8 = undefined;

    var sack_group: [3][]u8 = [_][]u8{undefined} ** 3;

    var part_one_sum: u32 = 0;
    var part_two_sum: u32 = 0;

    var sack_step: usize = 0;

    var start_count: usize = 0;
    var end_count: usize = 0;
    while (end_count < contents.len) : (end_count += 1) {

        //check that character is line terminator, and run line as provided
        if (contents[end_count] == '\n' or end_count == contents.len - 1) {
            sack = aid.allocator.alloc(u8, end_count - start_count) catch |err| return std.debug.print("{!}\n", .{err});

            //memcopy allegedly
            for (contents[start_count..end_count]) |c, i| sack[i] = c;

            //part one comparison of first and second halves of a sack
            comparison: for (sack[0..(sack.len >> 1)]) |s1|
                for (sack[(sack.len >> 1)..sack.len]) |s2|
                    if (s1 == s2) {
                        part_one_sum += if (s1 > 96) s1 - 96 else s1 - 38;
                        break :comparison;
                    };

            //add sack to group
            sack_group[sack_step] = sack;

            //increment sack step count
            sack_step += 1;
            if (sack_step > 2) {
                sack_step = 0;
                group_comparison: for (sack_group[0]) |s1|
                    for (sack_group[1]) |s2|
                        for (sack_group[2]) |s3|
                            if (s1 == s2 and s2 == s3) {
                                part_two_sum += if (s1 > 96) s1 - 96 else s1 - 38;
                                break :group_comparison;
                            };
                //_now_ free sacks
                aid.allocator.free(sack_group[0]);
                aid.allocator.free(sack_group[1]);
                aid.allocator.free(sack_group[2]);
            }
            //after all, set the start of the next line to the next character
            start_count = end_count + 1;
        }
    }

    if (print_output)
        aid.printResult(3, part_one_sum, part_two_sum) catch |err| return std.debug.print("{!}\n", .{err});
}
