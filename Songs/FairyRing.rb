### Fairy Ring V1
use_bpm 88
use_random_seed 8

#LOAD IN SAMPLE LIBRARIES
#Change to your own sample folder path:
pianoSample4 = "/Users/sheakennedy/Desktop/Elder Desktop/DESKTOP/Drum Kits _ Samples/Freesound/CC0/Insect/"
pianoSample3 = "/Users/sheakennedy/Desktop/Elder Desktop/DESKTOP/Drum Kits _ Samples/QY100 Chops/"
pianoSample2 = "/Users/sheakennedy/Desktop/Elder Desktop/DESKTOP/Drum Kits _ Samples/Breaks/SK01/"
pianoSample = "/Users/sheakennedy/Desktop/Elder Desktop/DESKTOP/Drum Kits _ Samples/Waldo/Loops/" #, 1,8,9,19

#LEVELS
inst0_lvl           = 1
inst1_lvl           = 1
inst2_lvl           = 1
inst3_lvl           = 1
inst4_lvl           = 1
inst5_lvl           = 1
inst6_lvl           = 1

live_loop :pianoEcho do
  with_fx :sound_out_stereo, output: 3 do  # ch 3-4
    if(inst0_lvl == 1)
      with_fx :level, amp: inst0_lvl do
        puts tick
        with_fx :echo, mix: 0.8 do
          sample pianoSample, 0, rate: (ring 8, 16).look, onset: (ring 3, 2, 2, 3, 7, 5, 3, 2).look, release: 0.01 if (spread 8, 16).look
        end
      end
    end
  end
  sleep 1
end

live_loop :piano do
  with_fx :sound_out_stereo, output: 5 do  # ch 5-6
    if(inst1_lvl == 1)
      with_fx :level, amp: choose([inst1_lvl])  do
        with_fx :bitcrusher do
          puts tick
          sample pianoSample, 0, rate: 0.5, beat_stretch: 16
        end
      end
    end
  end
  sleep 32
end

live_loop :piano2 do
  with_fx :sound_out_stereo, output: 7 do  # ch 7-8
    if(inst2_lvl == 1)
      with_fx :level, amp: choose([inst2_lvl])  do
        with_fx :bitcrusher do
          puts tick
          sample pianoSample2, 0, rate: 0.5, beat_stretch: 16
        end
      end
    end
  end
  sleep 32
end



live_loop :pianoGlitch do
  puts tick
  with_fx :sound_out_stereo, output: 9 do  # ch 9-10
    if(inst3_lvl == 1)
      with_fx :level, amp: choose([0, inst3_lvl, inst3_lvl, inst3_lvl])  do
        sample pianoSample, 1, rate: choose([2,4,8]), onset: (ring 1,0,0,2,6,4,5,  1,0,0,7,7,8,2,0).look, sustain: 0, release: 0.2 if (spread 12, 16).look
      end
    end
  end
  sleep 0.25
end

live_loop :pianoGlitch2 do
  puts tick
  with_fx :sound_out_stereo, output: 11 do  # ch 11-12
    if(inst4_lvl == 1)
      with_fx :level, amp: choose([0, inst4_lvl, inst4_lvl, inst4_lvl])  do
        sample pianoSample2, 1, rate: choose([2,4,8]), onset: (ring 1,0,0,2,6,4,5,  1,0,0,7,7,8,2,0).look, sustain: 0, release: 0.20 if (spread 12, 16).look
      end
    end
  end
  sleep 0.25
end

live_loop :pianoGlitch3 do
  puts tick
  with_fx :sound_out_stereo, output: 13 do  # ch 13-14
    if(inst5_lvl == 1)
      with_fx :level, amp: choose([0, inst5_lvl, inst5_lvl, inst5_lvl])  do
        with_fx :echo do
          with_fx :pan, pan: rrand(-0.4, 0.4) do
            sample pianoSample4, 14, rate: choose([2,4,8]), onset: (ring 1,0,0,2,6,4,5,  1,0,0,7,7,8,2,0).look, sustain: 0, release: 0.2 if (spread 12, 16).look
          end
        end
      end
    end
  end
  sleep 0.5
end
