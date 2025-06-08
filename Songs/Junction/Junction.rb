### Junction
# INITIALIZE MASTER VALUES
use_bpm 80
counter0 = 0
use_random_seed 0 #14 #8 #3

# LOAD IN SAMPLE LIBRARIES
sampleLibA = "/Users/sheakennedy/Desktop/Elder Desktop/DESKTOP/Drum Kits _ Samples/QY100 Samples/"
sampleLibB = "/Users/sheakennedy/Desktop/Elder Desktop/DESKTOP/Drum Kits _ Samples/Waldo/Loops/"

# AUTOMATION
lfo0 = (line 70, 100, inclusive: true, steps: 16).mirror
lfo0r = (line 100, 70, inclusive: true, steps: 16).mirror
lfo1 = (line 0.6, 0.1, inclusive: true, steps: 8).mirror
lfo2 = (line -1, 1, inclusive: true, steps: 16).mirror

# LEVELS
inst0_lvl           = 1
inst1_lvl           = 1
inst2_lvl           = 1
inst3_lvl           = 1
inst4_lvl           = 1

live_loop :amen do
  puts tick
  if(inst0_lvl != 0)
    with_fx :level, amp: inst0_lvl  do
      sample sampleLibA, 17, rate: (ring 0.5,0.5,0.125,0.25).look, beat_stretch: 16, onset: (ring 1,1,1,9,40,5,1,16).look,  release: 0.01
    end
  end
  sleep 0.125
end

live_loop :amen2 do
  puts tick
  if(inst1_lvl != 0)
    with_fx :level, amp: inst1_lvl  do
      with_fx :ping_pong, feedback: 0.5, mix: lfo1.look do
        sample sampleLibA, 17, rate: (ring 0.5,0.5,0.125,0.25).look, beat_stretch: 32, onset: (ring 1,1,1,9,40,5,1,16).look,  release: 0.01
      end
    end
  end
  sleep 1
end

live_loop :kick do
  puts tick
  if(inst2_lvl != 0)
    with_fx :level, amp: inst2_lvl  do
      # with_fx :normaliser do
      with_fx :lpf, cutoff: lfo0.look do
        sample sampleLibA, 21, rate: (ring 1).look, beat_stretch: 32, onset: (ring 2, 7, 6, 7).look,  release: 0.01
      end
      # end
    end
  end
  sleep (ring 0.25,0.5,0.125,0.125,0.5,0.125,0.25,0.125).look
end

live_loop :amen3 do
  puts tick
  if(inst3_lvl != 0)
    with_fx :level, amp: inst3_lvl  do
      with_fx :lpf, cutoff: lfo0.look do
        sample sampleLibB, 2, rate: (ring 1).look, beat_stretch: 4, onset: (ring 2, 7, 6, 7).look,  release: 0.01
      end
    end
  end
  sleep (ring 0.25,0.5,0.125,0.125,0.5,0.125,0.25,0.125).look
  
end

live_loop :amen4 do
  puts tick
  if(inst4_lvl != 0)
    with_fx :level, amp: inst4_lvl  do
      with_fx :lpf, cutoff: lfo0r.look do
        sample sampleLibB, 1, rate: (ring 16).look, beat_stretch: 32, onset: (ring 2, 7, 6, 7).look,  release: 0.01
      end
    end
  end
  sleep (ring 0.25,0.5,0.125,0.125,0.5,0.125,0.25,0.125).look
  
end
