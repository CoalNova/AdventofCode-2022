const std = @import("std");
const aid = @import("../aidingfunctions.zig");
const day = @embedFile("../dayinputs/day05_input.txt");

pub fn solveDay(print_output:bool) void {

    const max_crates : usize = 16;
    const max_stack : usize = 128;

    var lines = std.mem.split(u8, day, "\n");
    var crates : [max_crates][]u8 = [_][]u8{undefined} ** max_crates;
    var crates_r : [max_crates][]u8 = [_][]u8{undefined} ** max_crates;
    var crates_count : [max_crates]u32 = [_]u32{0} ** max_crates;
    var crates_count_r : [max_crates]u32 = [_]u32{0} ** max_crates;
    var c_counter : usize = 0;
    while (c_counter < crates.len) : (c_counter += 1)
    {
        crates[c_counter] = aid.allocator.alloc(u8, max_stack)
            catch |err| return std.debug.print("{!}", .{err});
        crates_r[c_counter] = aid.allocator.alloc(u8, max_stack)
            catch |err| return std.debug.print("{!}", .{err});
    }

    var stacks_width : usize = 0;

    crates_block:while (lines.next()) |line|{

        if(line[0] == '\n' or line[0] == 'm' or (line[1] >= 48 and line[1] < 58))
            break:crates_block;
        
        if (((line.len >> 2) + 1) > stacks_width) stacks_width = ((line.len >> 2) + 1);

        for(line) |char, index|
        {
            if (index > 0 and ((index - 1) & 3) == 0 and char >= 65 and char < 91)
            {
                var c_index = (index - 1) >> 2;
                crates[c_index][crates_count[c_index]] = char;
                crates_count[c_index] += 1;
            }
        }
    }

    for(crates[0..stacks_width]) |stack, index|
        std.mem.reverse(u8, stack[0..crates_count[index]]);
 
    for(crates[0..stacks_width])|crate, index|
    {
        for(crate)|char, c_index| crates_r[index][c_index] = char;
    }
    
    for (crates_count) |count, index| crates_count_r[index] = count;

    
    var ops : [3]u8 = [_]u8{0, 0, 0};
    var val : u8 = 0;
    var inc : u2 = 0;

    _ = lines.next();
    while (lines.next()) |line|
    {
        ops = [_]u8{0, 0, 0};
        val = 0;
        inc = 0;

        for(line) |char|
        {
            if (char >= 48 and char < 58) 
            {
                val = val * 10 + char - 48;
            }
            else if (val > 0)
            {
                ops[inc] = val;
                val = 0;
                inc += 1;
            }
        }
        ops[inc] = val;
        if (inc > 1)
        {
            var from_stack = ops[1] - 1;
            var to_stack = ops[2] - 1;
            var from_count = crates_count[ops[1] - 1];
            var to_count = crates_count[ops[2] - 1];
            var from_count_r = crates_count[ops[1] - 1];
            var to_count_r = crates_count[ops[2] - 1];

            for(crates[from_stack][from_count - ops[0]..from_count]) |crate, ind| 
                crates[to_stack][to_count + ind] = crate; 
                
            for(crates_r[from_stack][from_count_r - ops[0]..from_count_r]) |crate, ind| 
                crates_r[to_stack][to_count_r + ind] = crate; 
                
            std.mem.reverse(u8, crates[to_stack][to_count..to_count + ops[0]]);

            crates_count[from_stack] -= ops[0];
            crates_count[to_stack] += ops[0];

            crates_count_r[from_stack] -= ops[0];
            crates_count_r[to_stack] += ops[0];    
        }
    }

    // custom print here, as the output is not a numeric value
    if (print_output)
    {
        const stdout_file = std.io.getStdOut().writer();
        var bw = std.io.bufferedWriter(stdout_file);
        const stdout = bw.writer();

        stdout.print("Day 5\n\tPart1: ", .{})
            catch |err| return std.debug.print("{!}", .{err});
        for(crates[0..stacks_width]) |crate, index|
            stdout.print("{c}", .{crate[crates_count[index] - 1]})
                catch |err| return std.debug.print("{!}", .{err});
        
        stdout.print("\n\tPart2: ", .{})
                catch |err| return std.debug.print("{!}", .{err});
        for(crates_r[0..stacks_width]) |crate, index|
            stdout.print("{c}", .{crate[crates_count_r[index] - 1]})
                catch |err| return std.debug.print("{!}", .{err});

        stdout.print("\n", .{})
                catch |err| return std.debug.print("{!}", .{err});

        bw.flush() catch |err| return std.debug.print("{!}", .{err}); 
    }

    for(crates) |crate| aid.allocator.free(crate);
    for(crates_r) |crate| aid.allocator.free(crate);

}