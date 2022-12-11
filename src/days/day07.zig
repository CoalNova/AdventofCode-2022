const std = @import("std");
const aid = @import("../aidingfunctions.zig");
const day = @embedFile("../dayinputs/day07_input.txt");


pub fn solveDay(print_output : bool) void
{
    var part_one : u32 = 0;
    var part_two : u32 = 0;
    
    //perform the traversal
    var lines = std.mem.split(u8, day, "\n");
    _ = lines.next();


    var total_size = getSize("", &part_one, lines);

    var oughtta_size : u64 = 0;
    while (lines.next()) |line|
    {
        if (line.len > 0)
            if (line[0] >= 48 and line[0] < 58)
            {
                var line_sum : u64 = 0;
                for(line) |char|
                    line_sum = if (char >= 48 and char < 58) line_sum * 10 + char - 48 else line_sum;
                oughtta_size += line_sum;
            };
    }

    std.debug.print("{d} out of {d}\n", .{total_size, oughtta_size});

    if (print_output)
        aid.printResult(7, part_one, part_two) 
            catch |err| return std.debug.print("{!}", .{err});
}


//traversal
fn getSize(dir_slice : []const u8, part_one : *u32, from_lines : std.mem.SplitIterator(u8)) u32
{
    var size : u32 = 0;
    var lines = from_lines;
    var file_size : u32 = 0;

    //first op expects root character, supplied as "", so don't search
    if (dir_slice.len > 0)
    {
        hash_block:{
            while(lines.next()) |line|{
                //effectively just "find the line in the day's input where we 'cd' to the desired directory"
                if (line.len > 0)
                    if (line[0] == '$' and line[2] == 'c' and line [5] != '.'  and line [5] != '/' )
                       if (std.mem.eql(u8, dir_slice, line[5..]))
                            break : hash_block;                    
                    
            }        
            unreachable;
        } 
    }      

    //now that we've skipped to where we need to, let's process
    list_block:while (lines.next()) |line|
    {
        //check for the ending's \n, thank you AoC, very cool
        if (line.len > 0)
        {
            if (line[0] == '$')
            {
                //once we hit a command prompt list is finished
                if (line[2] == 'c')
                    break:list_block;
            } 
            else if (line[0] == 'd')
            {
                //hey looky, a directory, pass the directory name and dive right in.
                size += getSize(line[4..], part_one, lines);
            }
            else 
            {
                //get file size and add to the current size, use ascii table shifting to convert number
                file_size = 0;
                size_block:for(line) |char|
                {
                    if (char >= 48 and char < 58) 
                    {
                        file_size = file_size * 10 + char - 48; 
                    }
                    else 
                        break:size_block;
                }
                size += file_size;             
            }
        }
    }

    //final directory won't have any subsequent commands, so just leave as normal.
    if (size <= 100000)
        part_one.* += size;    

    return size;
}