const std = @import("std");

pub fn main() anyerror!void {
    // const result = try eval_input("input_example.txt", true);
    const result = try eval_input("input.txt", true);

    std.debug.print("Final-Score: P1={d}, P2={d}", .{ result.result_a, result.result_b });
}

const RoundEval = struct { result_a: u32, result_b: u32 };

// NORM:
// 0 -> Rock
// 1 -> Paper
// 2 -> Cissor
fn eval_input(file_path: []const u8, instructed_mode: bool) anyerror!RoundEval {
    var result_a: u32 = 0;
    var result_b: u32 = 0;

    const file = try std.fs.cwd().openFile(file_path, .{});
    defer file.close();

    var buf_reader = std.io.bufferedReader(file.reader());
    var in_stream = buf_reader.reader();
    var buf: [32]u8 = undefined;

    var i: u32 = 0;
    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        const a = line[0] - 'A';
        // space between values
        var b = line[2] - 'X';

        if (instructed_mode) {
            b = coose_instructed_shape(a, b);
        }

        var tmp_a = eval_shape(a);
        var tmp_b = eval_shape(b);

        const outcome = eval_outcome(a, b);
        tmp_a += outcome[0];
        tmp_b += outcome[1];

        result_a += tmp_a;
        result_b += tmp_b;

        std.debug.print("Result, round {d} => {s}: {d}={d} | {d}={d}\n", .{ i, line, a, tmp_a, b, tmp_b });

        i += 1;
    }

    return RoundEval{ .result_a = result_a, .result_b = result_b };
}

fn eval_shape(shape: u8) u8 {
    return shape + 1;
}

fn eval_outcome(a: u8, b: u8) [2]u8 {
    if (a == b) {
        return [_]u8{ 3, 3 };
    }

    if (a == 0) {
        if (b == 1) {
            return [_]u8{ 0, 6 };
        }
        return [_]u8{ 6, 0 };
    }

    if (a == 1) {
        if (b == 0) {
            return [_]u8{ 6, 0 };
        }
        return [_]u8{ 0, 6 };
    }

    if (b == 0) {
        return [_]u8{ 0, 6 };
    }
    return [_]u8{ 6, 0 };
}

fn coose_instructed_shape(shape: u8, instr: u8) u8 {
    if (instr == 0) {
        if (shape == 0) {
            return 2;
        }
        if (shape == 1) {
            return 0;
        }
        return 1;
    }

    if (instr == 1) {
        return shape;
    }

    if (shape == 0) {
        return 1;
    }
    if (shape == 1) {
        return 2;
    }
    return 0;
}
