const std = @import("std");
const fns = @import("../aidingfunctions.zig");
//Find the two entries that sum to 2020;
//what do you get if you multiply them together?

pub fn solveDay() void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    var input = fns.loadNumberList("./dayinputs/01-22_input.txt", allocator) catch |err| {
        std.debug.print("A oopsie occured during loading number list: {!}", .{err});
        return;
    };
    defer allocator.free(input);

    var solution_one: i32 = -1;
    var solution_two: i32 = -1;

    for (input) |primary, index| {
        if (solution_one != -1 and solution_two != -1) {
            break;
        }
        for (input[index..input.len]) |secondary, sub_index| {
            if (solution_one == -1 and primary + secondary == 2020) {
                solution_one = primary * secondary;
            }
            if (solution_two == -1) {
                for (input[sub_index..input.len]) |tertiary| {
                    if (primary + secondary + tertiary == 2020) {
                        solution_two = primary * secondary * tertiary;
                    }
                }
            }
        }
    }

    std.debug.print("Day One of 2020 part one: {d}\n", .{solution_one});
    std.debug.print("Day One of 2020 part two: {d}\n", .{solution_two});
}
