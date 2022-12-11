const std = @import("std");
const aid = @import("../aidingfunctions.zig");
const day = @embedFile("../dayinputs/day08_input.txt");

pub fn solveDay(print_output : bool) void
{
    var part_one : u32 = 0;
    var part_two : u32 = 0;


    var h : u32 = @intCast(u32, std.mem.count(u8, day, "\n"));
    var w : u32 = 0;
    for(day) |char, index|
    {
        if (char == '\n')
        {
            w = @intCast(u32, index);
            break;
        }
    }

    part_one = @intCast(u32, (w - 1) * 2 + (h - 1) * 2);

    var tree : u8 = 0;
    var blocked : u4 = 0;
    var s_score : [4]u32 = [_]u32{0} ** 4;
    var xshift : i64 = 0;
    var yshift : i64 = 0;
    var total_s_score : u32 = 0;

    var x : u32 = 1;
    var y : u32 = 1;
    while (y < h - 1) : (y += 1)
    {
        x = 1;
        while (x < w - 1) : (x += 1)
        {
            tree = day[x + y * (w + 1)];
            blocked = 0;
            s_score = [_]u32{x, w - x - 1, y, h - y - 1};
            xshift = x - 1;
            lex_blk : while (xshift >= 0) : (xshift -= 1)
                if (tree <= day[@intCast(u32, xshift) + y * (w + 1)])
                {
                    if (x - @intCast(u32, xshift) < s_score[0])
                        s_score[0] = x - @intCast(u32, xshift);
                    blocked = blocked | 0b0001; 
                    break : lex_blk;
                };

            xshift = x + 1;
            grx_blk : while (xshift < w + 1) : (xshift += 1)
                if (tree <= day[@intCast(u32, xshift) + y * (w + 1)])
                {
                    if (@intCast(u32, xshift) - x < s_score[1])
                        s_score[1] = @intCast(u32, xshift) - x;
                    blocked = blocked | 0b0010; 
                    break : grx_blk;
                };
            
            yshift = y - 1;
            ley_blk : while (yshift >= 0) : (yshift -= 1)
                if (tree <= day[x + @intCast(u32, yshift) * (w + 1)])
                {
                    if (y - @intCast(u32, yshift) < s_score[2])
                        s_score[2] = y - @intCast(u32, yshift);
                    blocked = blocked | 0b0100; 
                    break : ley_blk;
                };

            yshift = y + 1;
            gry_blk : while (yshift < h) : (yshift += 1)
                if (tree <= day[x + @intCast(u32, yshift) * (w + 1)])
                {
                    if (@intCast(u32, yshift) - y < s_score[3])
                        s_score[3] = @intCast(u32, yshift) - y;
                    blocked = blocked | 0b1000; 
                    break : gry_blk;
                };

            if (blocked < 0b1111)
            {
                total_s_score = 
                    s_score[0] * s_score[1] * s_score[2] * s_score[3];
                if (total_s_score > part_two)
                    part_two = total_s_score;
                
                part_one += 1;
            }
        }
    }


    if (print_output)
        aid.printResult(8, part_one, part_two)
            catch |err| std.debug.print("{!}\n", .{err});
}