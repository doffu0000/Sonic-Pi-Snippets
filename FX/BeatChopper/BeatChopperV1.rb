### Beat Chopper V1
use_bpm 90

# LOAD IN SAMPLE LIBRARIES
sampleLibA = "/Users/sheakennedy/Desktop/Elder Desktop/DESKTOP/Drum Kits _ Samples/QY100 Chops/"
sampleLibB = "/Users/sheakennedy/Desktop/Elder Desktop/DESKTOP/Drum Kits _ Samples/Waldo/Loops/"
sampleLibC = "/Users/sheakennedy/Desktop/Elder Desktop/DESKTOP/Drum Kits _ Samples/Breaks/SK01/"


# This live loop slices and plays small segments of the sample at random
live_loop :sliced_custom_sample do
  puts tick
  bs = 2.0
  n = 8
  s =  line(0, 1, steps: n).choose
  f = s + (1.0 / n)
  #sample sampleLibC, 10, beat_stretch: bs, start: s, finish: f
  sample :loop_amen, beat_stretch: bs, start: s, finish: f
  sleep bs  / n
end


