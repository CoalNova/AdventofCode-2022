const std = @import("std");
const aid = @import("../aidingfunctions.zig");
const day = @embedFile("../dayinputs/day09_input.txt");

const Position = struct{
    x : i32 = 0,
    y : i32 = 0
};

pub fn solveDay(print_output : bool) void
{
    var part_one : u32  = 0;
    var part_two : u32  = 0;

    const inst_count = std.mem.count(u8, day, "\n");
    var instructions : []u8 = aid.allocator.alloc(u8, inst_count) 
        catch |err| return std.debug.print("{!}\n", .{err});
    defer aid.allocator.free(instructions);

    var positions : []Position = aid.allocator.alloc(Position, inst_count * 10) 
        catch |err| return std.debug.print("{!}\n", .{err});
    defer aid.allocator.free(positions);

    var long_positions : []Position = aid.allocator.alloc(Position, inst_count * 10) 
        catch |err| return std.debug.print("{!}\n", .{err});
    defer aid.allocator.free(long_positions);

    var counter : usize = 0;
    var distance : u8 = 0;
    var lines = std.mem.split(u8, day, "\n");
    while (lines.next()) |line|
    {
        if (line.len > 0)
        {
            distance = 0;
            for(line[2..]) |char|
                distance = distance * 10 + char - 48;
            instructions[counter] = (@as(u8, @truncate(u2, line[0] / 3)) << 6) + distance;
            counter += 1;
        }
    }

    var head : Position = .{};
    var tail : Position = .{};
    var new_head : Position = .{};

    var long_tail : [9]Position = [_]Position{.{}} ** 9;

    for(instructions) |instruction|
    {
        var n : i16 = instruction;
        var step : u8 = 0;
        while(step < (n & 63)) : (step += 1)
        {
            new_head.x = head.x + (-1 + (n >> 7) * 2) * ((n >> 6) & 1);
            new_head.y = head.y + (1 - (n >> 7) * 2) * (1 - ((n >> 6) & 1));

            var abs_x =std.math.absInt(new_head.x - tail.x)
                catch |err| return std.debug.print("{!}\n", .{err});

            var abs_y =std.math.absInt(new_head.y - tail.y)
                catch |err| return std.debug.print("{!}\n", .{err});

            if ( abs_x > 1 or abs_y > 1)
            {
                tail.x = head.x;
                tail.y = head.y;
            }

            var old_pos = head;
            var new_pos = new_head;
            for(long_tail) |lt, id|
            {
                old_pos = lt;

                abs_x = std.math.absInt(new_pos.x - lt.x)
                    catch |err| return std.debug.print("{!}\n", .{err});

                abs_y = std.math.absInt(new_pos.y - lt.y)
                    catch |err| return std.debug.print("{!}\n", .{err});

                if ( abs_x > 1 or abs_y > 1)
                {
                    long_tail[id].x = old_pos.x;
                    long_tail[id].y = old_pos.y;
                }

                new_pos = long_tail[id];
            }

            head.x = new_head.x;
            head.y = new_head.y;


            long_match_block : {
                for(long_positions[0..part_two]) |position|
                {
                    if (position.x == long_tail[8].x and position.y == long_tail[8].y)
                        break : long_match_block;
                }
                long_positions[part_two] = tail;
                part_two += 1;
            }

            match_block : {
                for(positions[0..part_one]) |position|
                {
                    if (position.x == tail.x and position.y == tail.y)
                        break : match_block;
                }
                positions[part_one] = tail;
                part_one += 1;
            }
        }
    }

    if (print_output)
        aid.printResult(9, part_one, part_two)
            catch |err| return std.debug.print("{!}\n", .{err});
}