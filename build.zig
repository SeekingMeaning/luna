const Builder = @import("std").build.Builder;
const std = @import("std");
const mem = std.mem;
const builtin = @import("builtin");

pub fn build(b: *Builder) void {
    const source_files = [_][]const u8{
        "src/ast.c",
        "src/codegen.c",
        "src/errors.c",
        "src/hash.c",
        "src/lexer.c",
        "src/luna.c",
        "src/object.c",
        "src/parser.c",
        "src/prettyprint.c",
        "src/state.c",
        "src/string.c",
        "src/token.c",
        "src/utils.c",
        "src/vec.c",
        "src/visitor.c",
        "src/vm.c",
        "deps/linenoise/linenoise.c",
        "deps/linenoise/utf8.c",
    };

    const exe = b.addExecutable("luna", null);
    exe.linkSystemLibrary("c");

    exe.addIncludeDir("deps");
    exe.addIncludeDir("deps/linenoise");
    exe.addIncludeDir("src");

    const flags = &[_][]const u8{
        "-std=c99", "-g", "-O0", "-Wno-parentheses", "-Wno-switch-enum", "-Wno-unused-value",
        "-Wno-switch",
    };
    
    for (source_files) |source_file| {
        exe.addCSourceFile(source_file, flags);
    }

    if (builtin.os == .windows) {
        exe.defineCMacro("WIN32");
        exe.defineCMacro("__MINGW32__");
        exe.defineCMacro("strdup=_strdup");
        
        exe.addIncludeDir("deps/windows");
        exe.addIncludeDir("deps/windows/getopt");
        exe.addCSourceFile("deps/windows/getopt/getopt.c", flags);
    }

    exe.install();
}
