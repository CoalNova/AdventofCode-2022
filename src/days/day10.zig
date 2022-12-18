const std = @import("std");
const aid = @import("../aidingfunctions.zig");
const day = @embedFile("../dayinputs/day10_input.txt");


var part_one : u32 = 0;
var part_two : u32 = 0;
var tick : i64 = 0;
//speedregistor's secret brother who was thought to be dead, but unbeknownst to speed is actually alive and watches over him while hiding behind the secretive title of "register_x"!
var register_x : i64 = 1;

inline fn incTick() void
{
    // var tock = @mod(tick, 40);
    // if (tock == 0)
    //     std.debug.print("\n", .{});

    // if (tock == register_x or tock == register_x + 1 or tock == register_x - 1)
    // {
    //     std.debug.print("#", .{});
    // }
    // else
    // {
    //     std.debug.print(".", .{});
    // }

    tick += 1;

    if (@mod(tick - 20, 40) == 0)
        part_one = @intCast(u32, part_one + tick * register_x);
}

pub fn solveDay(print_output : bool) void 
{
    var inverter : i2 = 1;
    var value : i64 = 0;

    var lines = std.mem.split(u8, day, "\n");
    while (lines.next()) |line|
    {
        if (line[0] == 'n')
        {
            incTick();
        }       
        else
        {
            incTick();
            incTick();
            
            inverter = 1;
            value = 0;
            for(line) |char|
            {
                if (char == '-')
                {
                    inverter = -1;
                }
                else if (char >= 48 and char < 58)
                {
                    value = value * 10 + char - 48;
                }
            }
            value *= inverter;
            register_x = register_x + value;
        }
    }

    if (print_output)
        aid.printResult(10, part_one, part_two)
            catch |err| return std.debug.print("{!}\n", .{err});
}