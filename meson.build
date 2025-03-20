project('smpeg', ['c', 'cpp'],
  version : '0.4.5',
  default_options : [
    'warning_level=1',
    'buildtype=release',
    'c_std=gnu99',
    'cpp_std=c++11',
  ],
  meson_version : '>=0.50.0'
)

# Version values
major_version = 0
minor_version = 4
micro_version = 5
interface_age = 4
binary_age = 5

# Libtool versioning
lt_current = micro_version - interface_age
lt_revision = interface_age
lt_age = binary_age - interface_age

# Dependencies
sdl_dep = dependency('sdl', method : 'pkg-config', version : '>=1.2.0', required : true)
m_dep = meson.get_compiler('c').find_library('m', required : false)

# Build options
mmx_enabled = get_option('mmx')
ati_enabled = get_option('ati')
timestamp_sync = get_option('timestamp_sync')
threaded_system = get_option('threaded_system')
threaded_audio = get_option('threaded_audio')
gtk_player = get_option('gtk_player')
opengl_player = get_option('opengl_player')
debug_build = get_option('buildtype') == 'debug'

# Common compile flags
common_flags = []
common_flags += '-I' + meson.current_source_dir()
common_flags += '-I' + meson.current_source_dir() / 'audio'
common_flags += '-I' + meson.current_source_dir() / 'video'
common_flags += '-DNOCONTROLS'

if not debug_build
  common_flags += '-DNDEBUG'
endif

if mmx_enabled
  host_machine_cpu_family = host_machine.cpu_family()
  if host_machine_cpu_family == 'x86' or host_machine_cpu_family == 'x86_64'
    common_flags += '-DUSE_MMX'
  else
    warning('MMX requested but not supported on this CPU')
  endif
endif

if ati_enabled
  # We could check for ATI libraries here but we'll assume they're available
  # if the user explicitly enabled the option
  common_flags += '-DUSE_ATI'
endif

if timestamp_sync
  common_flags += '-DUSE_TIMESTAMP_SYNC'
endif

if threaded_system
  common_flags += '-DUSE_SYSTEM_THREAD'
endif

if threaded_audio
  common_flags += '-DTHREADED_AUDIO'
endif

add_project_arguments(common_flags, language: ['c', 'cpp'])

# For C++ compiler flags
cpp_compiler = meson.get_compiler('cpp')
if cpp_compiler.has_argument('-fno-exceptions') and cpp_compiler.has_argument('-fno-rtti')
  add_project_arguments(['-fno-exceptions', '-fno-rtti'], language: 'cpp')
endif

# Subdirectories
subdir('audio')

# Optional video subdirectory
audio_only = get_option('audio_only')
if not audio_only
  subdir('video')
endif

# Sources for the main library
smpeg_sources = [
  'MPEG.cpp',
  'MPEGring.cpp',
  'MPEGlist.cpp',
  'MPEGstream.cpp',
  'MPEGsystem.cpp',
  'MPEGfilter.c',
  'smpeg.cpp',
]

smpeg_headers = [
  'MPEG.h',
  'MPEGaction.h',
  'MPEGaudio.h',
  'MPEGerror.h',
  'MPEGfilter.h',
  'MPEGring.h',
  'MPEGlist.h',
  'MPEGstream.h',
  'MPEGsystem.h',
  'MPEGvideo.h',
  'smpeg.h',
]

# Main library
if audio_only
  smpeg_lib = library('smpeg',
    smpeg_sources,
    dependencies: [sdl_dep, m_dep],
    link_with: [audio_lib],
    version: '@0@.@1@.@2@'.format(lt_current, lt_age, lt_revision),
    soversion: lt_current,
    install: true,
  )
else
  smpeg_lib = library('smpeg',
    smpeg_sources,
    dependencies: [sdl_dep, m_dep],
    link_with: [audio_lib, video_lib],
    version: '@0@.@1@.@2@'.format(lt_current, lt_age, lt_revision),
    soversion: lt_current,
    install: true,
  )
endif

# Install headers
install_headers(smpeg_headers, subdir: 'smpeg')

# Dependency object for internal use
smpeg_dep = declare_dependency(
  include_directories: include_directories('.', 'audio', 'video'),
  link_with: smpeg_lib,
  dependencies: sdl_dep,
)

# Simple plaympeg player
if not audio_only
  executable('plaympeg',
    'plaympeg.c',
    dependencies: [smpeg_dep],
    install: true,
  )

  # GTK player (optional)
  if gtk_player
    gtk_dep = dependency('gtk+-2.0', version: '>=2.0.0', required: false)
    x11_dep = dependency('x11', required: false)
    
    if gtk_dep.found() and x11_dep.found()
      executable('gtv',
        ['gtv.c', 'gtv.h'],
        dependencies: [smpeg_dep, gtk_dep, x11_dep],
        install: true,
      )
    endif
  endif

  # OpenGL player (optional)
  if opengl_player
    gl_deps = []
    
    if host_machine.system() == 'windows'
      gl_deps += [meson.get_compiler('c').find_library('opengl32'), 
                  meson.get_compiler('c').find_library('glu32')]
    elif host_machine.system() == 'darwin'
      # macOS OpenGL framework is handled automatically
    else
      x11_dep = dependency('x11', required: false)
      gl_dep = dependency('gl', required: false)
      glu_dep = dependency('glu', required: false)
      
      if x11_dep.found() and gl_dep.found() and glu_dep.found()
        gl_deps += [x11_dep, gl_dep, glu_dep]
      endif
    endif
    
    if gl_deps.length() > 0 or host_machine.system() == 'darwin'
      executable('glmovie',
        ['glmovie-tile.c', 'glmovie.c', 'glmovie.h'],
        dependencies: [smpeg_dep] + gl_deps,
        install: true,
      )
    endif
  endif
endif

# Generate a pkg-config file
pkg = import('pkgconfig')
pkg.generate(
  name: 'smpeg',
  description: 'SDL MPEG Player Library',
  version: meson.project_version(),
  libraries: smpeg_lib,
  requires: 'sdl >= 1.2.0',
)

# Summary
message('SMPEG configuration:')
message('  Audio only:        @0@'.format(audio_only))
message('  MMX support:       @0@'.format(mmx_enabled))
message('  ATI support:       @0@'.format(ati_enabled))
message('  Timestamp sync:    @0@'.format(timestamp_sync))
message('  Threaded system:   @0@'.format(threaded_system))
message('  Threaded audio:    @0@'.format(threaded_audio))
message('  GTK player:        @0@'.format(gtk_player and not audio_only))
message('  OpenGL player:     @0@'.format(opengl_player and not audio_only))