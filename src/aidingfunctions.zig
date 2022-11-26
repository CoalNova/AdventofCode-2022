const std = @import("std");

pub fn loadNumberList(filename: []const u8, allocator: std.mem.Allocator) ![]i32 {
    var file = try std.fs.cwd().openFile(filename, .{});
    var char_list = try file.readToEndAlloc(allocator, (1 << 32) - 1);
    std.debug.assert(char_list.len != 0);

    var list = try allocator.alloc(i32, 4);
    var count: usize = 0;

    var val: i32 = 0;
    for (char_list) |char| {
        if (char >= 48 and char < 58) {
            val *= 10;
            val += char - 48;
        } else if (val != 0) {
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
    allocator.free(list);
    return final_list;
}
