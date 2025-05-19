const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    _ = b.addModule("structures", .{
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize,
    });

    const stack_test = b.addTest(.{
        .root_source_file = b.path("src/stack.zig"),
        .target = target,
        .optimize = optimize,
    });

    const queue_test = b.addTest(.{
        .root_source_file = b.path("src/queue.zig"),
        .target = target,
        .optimize = optimize
    });

    const testing = b.step("tests", "Testing the data structures.");
    testing.dependOn(&queue_test.step);
    testing.dependOn(&stack_test.step);
}
