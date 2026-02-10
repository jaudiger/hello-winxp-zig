const std = @import("std");

pub fn build(b: *std.Build) void {
    const exe = b.addExecutable(.{
        .name = "hello-zigwin",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/main.zig"),
            .target = b.resolveTargetQuery(.{
                .cpu_arch = .x86,
                .os_tag = .windows,
                .os_version_min = .{ .windows = .xp },
            }),
            .optimize = .ReleaseSmall,
        }),
    });

    exe.subsystem = .Windows;
    exe.build_id = .none;
    exe.linker_dynamicbase = false;

    b.installArtifact(exe);
}
