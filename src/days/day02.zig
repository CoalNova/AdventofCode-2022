const std = @import("std");
const aid = @import("../aidingfunctions.zig");

pub fn solveDay(print_output: bool) void {
    var inputs = aid.loadFile("./dayinputs/day02_input.txt") catch |err| return std.debug.print("{!}\n", .{err});
    defer aid.allocator.free(inputs);

    var hand1: i16 = 0;
    var hand2: i16 = 0;
    var part_one_score: u32 = 0;
    var part_two_score: u32 = 0;
    var part_two_hand: i64 = 0;

    var index: usize = 0;
    while (index < inputs.len) : (index += 4) {
        //ascii value of A-C is 65-67
        hand1 = inputs[index] - 65;

        //ascii value of X-Z is 88-90
        hand2 = inputs[index + 2] - 88;

        //part one, get played hand and score against own hand
        //3 times a boolean match to get a draw scenario
        //6 multiplied by either the obvious win, or the rounded edge case
        part_one_score += @intCast(u32, hand2 + 1) + 3 * @intCast(u32, @boolToInt(hand1 == hand2)) +
            6 * @intCast(u32, @boolToInt(hand2 - hand1 == 1)) +
            6 * @intCast(u32, @boolToInt(hand1 == 2 and hand2 == 0));

        //calculate what the required hand is needed to reach provided outcome
        //selectively force values for edge cases
        part_two_hand = @intCast(i64, hand1 + 1 + hand2 - 1 + @as(i64, 3) * @boolToInt(hand1 + hand2 == 0) - @as(i64, 3) * @boolToInt(hand1 + hand2 == 4));

        //multiply 3 by the required game outcome and add the required hand
        part_two_score += 3 * @intCast(u32, hand2) + @intCast(u32, part_two_hand);
    }

    if (print_output)
        aid.printResult(2, part_one_score, part_two_score) catch |err| return std.debug.print("{!}\n", .{err});
}
