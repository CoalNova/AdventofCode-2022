const std = @import("std");
const aid = @import("../aidingfunctions.zig");
const day = @embedFile("../dayinputs/day06_input.txt");

pub fn solveDay(print_output : bool) void
{
    var part_one : u32 = 0;
    var part_two : u32 = 0;

    var slots : [4]u8 = [_]u8{0}**4;
    var message : [14]u8 = [_]u8{0}**14;

    var slot_found : bool = false;
    var message_found : bool = false;

    day_blk:for(day) |char, index|
    {
        slots[index & 3] = char;
        message[index % 14] = char;
        
        if (index > 3 and !slot_found)  
        slt_blk:{

            for(slots) |slot_a, slot_index|
                for(slots[slot_index+1..]) |slot_b|
                    if (slot_a == slot_b)
                        break : slt_blk;
            
            part_one = @intCast(u32, index + 1);
            slot_found = true;
        }

        if (index > 13 and !message_found)
        msg_blk:{

            for(message) |m_a, m_index|
                for(message[m_index + 1..]) |m_b|
                    if (m_a == m_b)
                        break : msg_blk;
            
            part_two = @intCast(u32, index + 1);
            message_found = true;
        }
        if (message_found and slot_found)
            break : day_blk;
    }


    if (print_output)
        aid.printResult(6, part_one, part_two)
            catch |err| return std.debug.print("{!}", .{err});
}