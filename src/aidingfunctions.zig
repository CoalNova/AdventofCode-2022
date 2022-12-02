const std = @import("std");

var gpa = std.heap.GeneralPurposeAllocator(.{}){};
pub const allocator = gpa.allocator();

pub fn loadFile(filename: []const u8) ![]u8
{
    var file = try std.fs.cwd().openFile(filename, .{});
    var char_list = try file.readToEndAlloc(allocator, (1 << 32) - 1);
    file.close();
    return char_list;
}

pub fn parseNumberList(char_list : []const u8) ![]i32 {
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

pub fn benchmarkDay(day : u8, day_solution : *const fn(bool)void, reps : u32) void
{
    const time = std.time;

    var timer = time.Timer.start() catch |err| return std.debug.print("{!}", .{err});
    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();

    var avg : u64 = 0;
    var upr : u64 = 0;
    var lwr : u64 = (1 << 64) - 1;
    var x : u32 = 0;
    while (x < reps) : (x += 1)
    {
        day_solution(false);
        var lap = timer.lap();
        avg += lap;
        if (lap > upr) upr = lap;
        if (lap < lwr) lwr = lap;
    }

    avg = avg / reps;

    stdout.print("Day {d} total average time over {d} repetitions: {d} ms\n", 
        .{day, reps, @intToFloat(f32, avg) / @intToFloat(f32, time.ns_per_ms)}) 
            catch |err| return std.debug.print("{!}", .{err});
    stdout.print("  Longest time: {d} ms, shortest time: {d} ms\n", 
        .{@intToFloat(f32, upr) / @intToFloat(f32, time.ns_per_ms), @intToFloat(f32, lwr) / @intToFloat(f32, time.ns_per_ms)}) 
            catch |err| return std.debug.print("{!}", .{err});
    bw.flush() catch |err| std.debug.print("{!}", .{err});
}

