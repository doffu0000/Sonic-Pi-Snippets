### Courtship Trance V1
use_bpm 75
counter0 = 0
use_random_seed 8 #14 #8 #3#

#LOAD IN SAMPLE LIBRARIES
#Change to your own sample folder paths.
barretA = "/Users/sheakennedy/Desktop/Elder Desktop/DESKTOP/Drum Kits _ Samples/Freesound/CC0/Insect/"
barretDrum = "/Users/sheakennedy/Desktop/Elder Desktop/DESKTOP/Drum Kits _ Samples/Homebrew/Barret Drums/"
barretBreak = "/Users/sheakennedy/Desktop/Elder Desktop/DESKTOP/Drum Kits _ Samples/QY100 Chops/"
barretB = "/Users/sheakennedy/Desktop/Elder Desktop/DESKTOP/Drum Kits _ Samples/Freesound/CC0/Bird/"
barretC = "/Users/sheakennedy/Desktop/Elder Desktop/DESKTOP/Drum Kits _ Samples/Freesound/CC0/Insect/"
barretD = "/Users/sheakennedy/Desktop/Elder Desktop/DESKTOP/Drum Kits _ Samples/Homebrew/Barret Loops/D"
barretE = "/Users/sheakennedy/Desktop/Elder Desktop/DESKTOP/Drum Kits _ Samples/Breaks/SK01/"
barretF = "/Users/sheakennedy/Desktop/Elder Desktop/DESKTOP/Drum Kits _ Samples/Homebrew/Barret Loops/F"
barretG = "/Users/sheakennedy/Desktop/Elder Desktop/DESKTOP/Drum Kits _ Samples/Homebrew/Barret Loops/G"

#AUTOMATION
line_Riser0 = (line 10, 0, inclusive: true, steps: 16)
line_Riser1 = (line 8, 0, inclusive: true, steps: 128)
line_Riser2 = (line 4, 0, inclusive: true, steps: 128)
lfo0 = (line 70, 100, inclusive: true, steps: 16).mirror
lfo1 = (line 0.8, 0.99, inclusive: true, steps: 32).mirror
lfo2 = (line 120, 60, inclusive: true, steps: 4).mirror
lfo3 = (line 120, 100, inclusive: true, steps: 8)
lfo4 = (line 0.7, 0.99, inclusive: true, steps: 4).mirror
lfo5 = (line 0.3, 0.99, inclusive: true, steps: 2).mirror

#LEVELS
inst0_lvl           = 1
inst2_lvl           = 1
inst3_lvl           = 1
inst5_lvl           = 1
inst6_lvl           = 1
inst7_lvl           = 1
inst8_lvl           = 1
inst9_lvl           = 1
inst10_lvl          = 1

live_loop :euclid_beat2 do
  with_fx :sound_out_stereo, output: 3 do  # ch 3-4
    if(inst0_lvl == 1)
      with_fx :level, amp: inst0_lvl do
        puts tick
        with_fx :echo, mix: 0.8 do
          sample barretA, 6, rate: 8, onset: 1, release: 0.01 if (spread 8, 16).look
        end
      end
    end
  end
  sleep 4
end

live_loop :elevator2 do
  with_fx :sound_out_stereo, output: 5 do  # ch 5-6
    if(inst2_lvl == 1)
      with_fx :level, amp: choose([1])  do
        puts tick
        sample barretA, 1, rate: 1
      end
    end
  end
  sleep 8
end

live_loop :elevator3 do
  with_fx :sound_out_stereo, output: 7 do  # ch 7-8
    if(inst3_lvl == 1)
      with_fx :level, amp: choose([1])  do
        puts tick
        sample barretA, 0, rate: 1, release: 0.01
      end
    end
  end
  sleep 16
end

live_loop :trip do
  puts tick
  with_fx :sound_out_stereo, output: 9 do  # ch 9-10
    if(inst5_lvl == 1)
      with_fx :level, amp: choose([1])  do
        with_fx :slicer, phase: 2 do
          with_fx :lpf, cutoff: lfo0.look, res: lfo1.look do
            sample barretB, choose([6, 10]), rate: (ring 2, 0.5).look, onset: (ring 1,0,0,2,6,4,5,  1,0,0,7,7,8,2,0).look , release: 0.01
          end
        end
      end
    end
  end
  sleep (ring 0.5, 0.25, 0.5, 0.25).mirror.look #(ring 0.5, 0.125, 0.125,0.25)
end

live_loop :trip2 do
  puts tick
  with_fx :sound_out_stereo, output: 11 do  # ch 11-12
    if(inst6_lvl == 1)
      with_fx :level, amp: choose([1])  do
        sample barretA, 11, rate: (ring 2, 4).look, onset: (ring 2, 4, 4, 7).look, release: 0.01 if (spread 16, 16).look
      end
    end
  end
  sleep (ring 0.5, 0.25, 0.25).look #Switch between these to change pacing
  #sleep (ring 0.25, 0.125, 0.125).look
end

live_loop :elevator0 do
  with_fx :sound_out_stereo, output: 13 do  # ch 13-14
    if(inst7_lvl == 1)
      puts tick
      with_fx :level, amp: (ring 0, 0, 0, 0, 1, 1, 1, 1).look  do
        with_fx :hpf do
          with_fx :bitcrusher do
            sample barretE, 0, rate: 1, onset: 3, release: 0.01
          end
        end
      end
    end
  end
  sleep (ring 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5).look
end

live_loop :elevator do
  with_fx :sound_out_stereo, output: 15 do  # ch 15-16
    if(inst8_lvl == 1)
      puts tick
      sample barretE, 0, rate: 1, onset: 3, release: 0.01
    end
  end
  sleep (ring 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.25, 0.25).look
end

live_loop :amen2 do
  with_fx :sound_out_stereo, output: 17 do  # ch 17-18
    if(inst9_lvl == 1)
      puts tick
      with_fx :level, amp: choose([0.8,1])  do
        sample barretC, 9, rate: (ring 2, 2, 2, 2, 2, 2, 1, 4).look, onset: pick, sustain: 0, release: choose([0.1])
      end
    end
  end
  sleep 0.25
end


live_loop :amen3 do
  with_fx :sound_out_stereo, output: 19 do  # ch 19-20
    if(inst10_lvl == 1)
      puts tick
      with_fx :level, amp: choose([1,1])  do
        sample barretBreak, 0, rate: 1, onset: pick, sustain: 0, release: choose([0.1, 0.2])
      end
    end
  end
  sleep 0.125
end
