workspace "pigz"
    language "C"
    cdialect "C11"
    symbols "On"
    debugformat "c7"
    characterset "Unicode"
    nativewchar "On"
    editandcontinue "Off"
    warnings "Extra"
    justmycode "Off"

    flags {
        "FatalWarnings",
        "MultiProcessorCompile",
        "NoIncrementalLink",
    }

    configurations {
        "Release"
    }

    platforms {
        "x64",
    }

    location (string.upper(_ACTION))

    filter "Debug"
        optimize "Off"

        defines {
            "DEBUG",
            "SCRIPT_DEBUG",
        }

    filter "Release"
        optimize "Full"

        defines {
            "NDEBUG",
        }

    filter "system:Windows"
        defines {
            "_CRT_SECURE_NO_WARNINGS",
        }

        disablewarnings {
            "4100",
            "4127",
            "4232",
            "4244",
            "4267",
            "4305",
            "4313",
            "4456",
            "4457",
            "4459",
            "4473",
            "4477",
            "4701",
            "4996",
        }

        includedirs {
            "external/windows_posix/",
        }

    includedirs {
        "external/zlib/",
    }

project "libz"
    kind "StaticLib"

    files {
        "external/zlib/*.h",
        "external/zlib/adler32.c",
        "external/zlib/compress.c",
        "external/zlib/crc32.c",
        "external/zlib/deflate.c",
        "external/zlib/inflate.c",
        "external/zlib/infback.c",
        "external/zlib/inftrees.c",
        "external/zlib/inffast.c",
        "external/zlib/trees.c",
        "external/zlib/uncompr.c",
        "external/zlib/zutil.c",
    }

project "windows_posix"
    kind "StaticLib"

    files {
        "external/windows_posix/**",
    }

project "core"
    kind "StaticLib"

    files {
        "zopfli/src/zopfli/blocksplitter.c",
        "zopfli/src/zopfli/cache.c",
        "zopfli/src/zopfli/deflate.c",
        "zopfli/src/zopfli/hash.c",
        "zopfli/src/zopfli/katajainen.c",
        "zopfli/src/zopfli/lz77.c",
        "zopfli/src/zopfli/squeeze.c",
        "zopfli/src/zopfli/symbols.c",
        "zopfli/src/zopfli/tree.c",
        "zopfli/src/zopfli/util.c",
    }

project "pigz"
    kind "ConsoleApp"

    files {
        "pigz.c",
        "try.c",
        "yarn.c",
    }

    links {
        "core",
        "libz",
    }

project "pigzj"
    kind "ConsoleApp"

    defines {
        "NOZOPFLI",
    }

    files {
        "pigz.c",
        "try.c",
        "yarn.c",
    }

    links {
        "libz",
    }

project "pigzt"
    kind "ConsoleApp"

    defines {
        "PIGZ_DEBUG",
    }

    files {
        "pigz.c",
        "try.c",
        "yarn.c",
    }

    links {
        "core",
        "libz",
    }

project "pigzn"
    kind "ConsoleApp"

    defines {
        "PIGZ_DEBUG",
        "NOTHREAD",
    }

    files {
        "pigz.c",
        "try.c",
        "yarn.c",
    }

    links {
        "core",
        "libz",
    }
