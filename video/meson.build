video_sources = [
  'MPEGvideo.cpp',
  'decoders.cpp',
  'floatdct.cpp',
  'gdith.cpp',
  'jrevdct.cpp',
  'motionvector.cpp',
  'parseblock.cpp',
  'readfile.cpp',
  'util.cpp',
  'video.cpp',
  'vhar128.cpp',
]

# Handle assembly files for MMX support
if mmx_enabled and (host_machine.cpu_family() == 'x86' or host_machine.cpu_family() == 'x86_64')
  if host_machine.system() == 'windows'
    # Windows assembly handling might need different approach
    video_sources += ['mmxflags_asm.S', 'mmxidct_asm.S']
  else
    # On Unix-like systems we can use the assembly files directly
    video_sources += ['mmxflags_asm.S', 'mmxidct_asm.S']
  endif
endif

video_lib = static_library('video',
  video_sources,
  dependencies: [sdl_dep],
  include_directories: include_directories('..'),
)