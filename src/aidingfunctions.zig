const std = @import("std");

pub fn loadFile(filename: []const u8, allocator: std.mem.Allocator) []u8
{
    var file = try std.fs.cwd().openFile(filename, .{});
    var char_list = try file.readToEndAlloc(allocator, (1 << 32) - 1);
    return char_list;
}

pub fn parseNumberList(char_list : []const u8,  allocator: std.mem.Allocator) ![]i32 {
    var list = try allocator.alloc(i32, 4);
    defer allocator.free(list);
    var count: usize = 0;

    var val: i32 = 0;
    var set: bool = false;
    for (char_list) |char| {
        if (char >= 48 and char < 58) {
            val *= 10;
            val += char - 48;
            set = true;
        } else if (set) {
            if (count >= list.len) {
                var new_list = try allocator.alloc(i32, list.len * 2);
                //steering not included
                for (list[0..list.len]) |n, i| new_list[i] = n;
                allocator.free(list);
                list = new_list;
            }
            list[count] = val;
            count = count + 1;
            val = 0;
        }
    }
    var final_list = try allocator.alloc(i32, count);
    for (list[0..count]) |n, i| final_list[i] = n;
    return final_list;
}

pub fn printResult(day : u8, part1 : u32, part2 : u32) !void
{
    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();

    try stdout.print("Day {d}\n\tPart1: {d}\n\tPart2: {d}\n", .{day, part1, part2});

    try bw.flush(); // don't forget to flush!
}

pub fn benchmarkDay(day : *const fn()void, reps : u32) void
{
    const time = std.time;

    var timer = time.Timer.start() catch |err| return std.debug.print("{!}", .{err});
    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();

    var avg : u64 = 0;
    var x : u32 = 0;
    while (x < reps) : (x += 1)
    {
        day();
        var lap = timer.lap();
        avg += lap;
        stdout.print("time: {d}.{d} ms\n", .{lap / time.ns_per_ms, @mod(lap, time.ns_per_ms)}) catch |err| return std.debug.print("{!}", .{err});
    }

    avg = avg / reps;

    stdout.print("total average time over {d} repetitions: {d}.{d} ms\n", .{reps, avg / time.ns_per_ms, @mod(avg, time.ns_per_ms)}) catch |err| return std.debug.print("{!}", .{err});
    bw.flush() catch |err| std.debug.print("{!}", .{err});
}
