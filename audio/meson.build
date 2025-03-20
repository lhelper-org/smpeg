audio_sources = [
  'MPEGaudio.cpp',
  'bitwindow.cpp',
  'filter.cpp',
  'filter_2.cpp',
  'huffmantable.cpp',
  'mpeglayer1.cpp',
  'mpeglayer2.cpp',
  'mpeglayer3.cpp',
  'mpegtable.cpp',
  'mpegtoraw.cpp',
]

audio_lib = static_library('audio',
  audio_sources,
  dependencies: [sdl_dep],
  include_directories: include_directories('..'),
)