const std = @import("std");
const builtin = @import("builtin");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const memview_lib = b.addStaticLibrary(.{
        .name = "memview",
        .root_source_file = .{
            .path = "lib/memview/host.zig",
        },
        .target = target,
        .optimize = optimize,
    });

    const exe = b.addExecutable(.{
        .name = "doomgeneric",
        .target = target,
        .optimize = optimize,
    });

    const c_compile_opts = [_][]const u8{
        "-std=c99",
        "-fno-sanitize=undefined",
    };

    exe.addIncludePath("lib/memview");
    // exe.addLibraryPath("lib/memview");
    // exe.linkSystemLibrary("memview");
    exe.linkSystemLibrary("gdi32");
    exe.linkLibC();
    exe.linkLibrary(memview_lib);
    exe.addCSourceFiles(
        &.{
            "doomgeneric/am_map.c",
            "doomgeneric/doomdef.c",
            "doomgeneric/doomgeneric.c",
            // "doomgeneric/doomgeneric_sdl.c",
            // "doomgeneric/doomgeneric_soso.c",
            // "doomgeneric/doomgeneric_sosox.c",
            // "doomgeneric/doomgeneric_win.c",
            // "doomgeneric/doomgeneric_xlib.c",
            "doomgeneric/doomstat.c",
            "doomgeneric/dstrings.c",
            "doomgeneric/dummy.c",
            "doomgeneric/d_event.c",
            "doomgeneric/d_items.c",
            "doomgeneric/d_iwad.c",
            "doomgeneric/d_loop.c",
            "doomgeneric/d_main.c",
            "doomgeneric/d_mode.c",
            "doomgeneric/d_net.c",
            "doomgeneric/f_finale.c",
            "doomgeneric/f_wipe.c",
            "doomgeneric/gusconf.c",
            "doomgeneric/g_game.c",
            "doomgeneric/hu_lib.c",
            "doomgeneric/hu_stuff.c",
            "doomgeneric/icon.c",
            "doomgeneric/info.c",
            "doomgeneric/i_cdmus.c",
            "doomgeneric/i_endoom.c",
            "doomgeneric/i_input.c",
            "doomgeneric/i_joystick.c",
            "doomgeneric/i_scale.c",
            // "doomgeneric/i_sdlmusic.c",
            // "doomgeneric/i_sdlsound.c",
            "doomgeneric/i_sound.c",
            "doomgeneric/i_system.c",
            "doomgeneric/i_timer.c",
            "doomgeneric/i_video.c",
            "doomgeneric/memio.c",
            "doomgeneric/mus2mid.c",
            "doomgeneric/m_argv.c",
            "doomgeneric/m_bbox.c",
            "doomgeneric/m_cheat.c",
            "doomgeneric/m_config.c",
            "doomgeneric/m_controls.c",
            "doomgeneric/m_fixed.c",
            "doomgeneric/m_menu.c",
            "doomgeneric/m_misc.c",
            "doomgeneric/m_random.c",
            "doomgeneric/p_ceilng.c",
            "doomgeneric/p_doors.c",
            "doomgeneric/p_enemy.c",
            "doomgeneric/p_floor.c",
            "doomgeneric/p_inter.c",
            "doomgeneric/p_lights.c",
            "doomgeneric/p_map.c",
            "doomgeneric/p_maputl.c",
            "doomgeneric/p_mobj.c",
            "doomgeneric/p_plats.c",
            "doomgeneric/p_pspr.c",
            "doomgeneric/p_saveg.c",
            "doomgeneric/p_setup.c",
            "doomgeneric/p_sight.c",
            "doomgeneric/p_spec.c",
            "doomgeneric/p_switch.c",
            "doomgeneric/p_telept.c",
            "doomgeneric/p_tick.c",
            "doomgeneric/p_user.c",
            "doomgeneric/r_bsp.c",
            "doomgeneric/r_data.c",
            "doomgeneric/r_draw.c",
            "doomgeneric/r_main.c",
            "doomgeneric/r_plane.c",
            "doomgeneric/r_segs.c",
            "doomgeneric/r_sky.c",
            "doomgeneric/r_things.c",
            "doomgeneric/sha1.c",
            "doomgeneric/sounds.c",
            "doomgeneric/statdump.c",
            "doomgeneric/st_lib.c",
            "doomgeneric/st_stuff.c",
            "doomgeneric/s_sound.c",
            "doomgeneric/tables.c",
            "doomgeneric/v_video.c",
            "doomgeneric/wi_stuff.c",
            "doomgeneric/w_checksum.c",
            "doomgeneric/w_file.c",
            "doomgeneric/w_file_stdc.c",
            "doomgeneric/w_main.c",
            "doomgeneric/w_wad.c",
            "doomgeneric/z_zone.c",
        },
        &c_compile_opts,
    );

    const target_os = if (target.os_tag) |tag| tag else builtin.os.tag;

    if (target_os == .windows) {
        exe.addCSourceFiles(&.{"doomgeneric/doomgeneric_win.c"}, &c_compile_opts);
    } else {
        exe.addCSourceFiles(&.{
            "doomgeneric/doomgeneric_sdl.c",
            "doomgeneric/i_sdlmusic.c",
            "doomgeneric/i_sdlsound.c",
        }, &c_compile_opts);
    }

    exe.install();
}
