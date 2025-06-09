### Shell V1
use_bpm 48 #48
use_random_seed 10

# Sample Libraries
sampleLibA = "/Users/sheakennedy/Desktop/Elder Desktop/DESKTOP/Drum Kits _ Samples/QY100 Samples/"
sampleLibB = "/Users/sheakennedy/Desktop/Elder Desktop/DESKTOP/Drum Kits _ Samples/Waldo/Loops/", 17
barretInsect = "/Users/sheakennedy/Desktop/Elder Desktop/DESKTOP/Drum Kits _ Samples/Freesound/CC0/Insect/"
barretBird = "/Users/sheakennedy/Desktop/Elder Desktop/DESKTOP/Drum Kits _ Samples/Freesound/CC0/Bird/"
barretBreak = "/Users/sheakennedy/Desktop/Elder Desktop/DESKTOP/Drum Kits _ Samples/QY100 Chops/"

# Automation LFOs
lfo_cut = (line 70, 100, inclusive: true, steps: 4).mirror
lfo_cut2 = (line 90, 110, inclusive: true, steps: 32).mirror
lfo_res = (line 0.6, 0.1, inclusive: true, steps: 16).mirror
lfo_amp = (line 1, 0.2, inclusive: true, steps: 8).mirror
lfo_pan = (line -1, 1, inclusive: true, steps: 16).mirror

# Levels
inst_fxbreak = 1
inst_noise = 1
inst_chopbird = 1
inst_chopbird2 = 1
inst_insect = 1

live_loop :fxbreak_sweep do
  with_fx :sound_out_stereo, output: 3 do
    if inst_fxbreak > 0
      with_fx :level, amp: inst_fxbreak do
        with_fx :ping_pong, feedback: 0.6, mix: lfo_res.look do
          sample sampleLibB, 2, rate: -1, beat_stretch: 8,
            onset: (ring 7).tick, release: 0.1
        end
      end
    end
  end
  sleep 8
end

live_loop :bird_chops do
  with_fx :sound_out_stereo, output: 5 do
    if inst_chopbird > 0
      with_fx :level, amp: inst_chopbird do
        with_fx :pan, pan: lfo_pan.tick do
          sample barretBird, 0, rate: 2, onset: (ring 0, 1, 3, 5, 7).choose,
            release: 0.08
        end
      end
    end
  end
  sleep 0.25
end

live_loop :bird_chops2 do
  puts tick
  with_fx :sound_out_stereo, output: 6 do
    if inst_chopbird2 > 0
      with_fx :level, amp: inst_chopbird2 do
        with_fx :pan, pan: lfo_pan.tick do
          with_fx :lpf, cutoff: lfo_cut2.tick do
            sample barretBird, 7, rate: 2, onset: (ring 0, 1, 3, 5, 7, 7, 5, 3).look, release: 0.08
          end
        end
      end
    end
  end
  sleep 0.125
end

live_loop :ambience_insect do
  with_fx :sound_out_stereo, output: 7 do
    if inst_insect > 0
      with_fx :level, amp: 1 do
        with_fx :echo, mix: 0.5, phase: 0.5 do
          
          sample barretInsect, 2, rate: 4, onset: 1, release: 0.1, start: 0, finish: 0.25
        end
      end
    end
    sleep 4
  end
end


