const aid = @import("./aidingfunctions.zig");
const d01 = @import("./days/day01.zig");

pub fn main() void {
    //d01.solveDay();
    aid.benchmarkDay(&d01.solveDay, 1000);
}
