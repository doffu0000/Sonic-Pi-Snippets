### Cave V1
use_bpm 16
use_random_seed 42

# === Sample Libraries ===
sampleLibA = "/Users/sheakennedy/Desktop/Elder Desktop/DESKTOP/Drum Kits _ Samples/QY100 Samples/"
sampleLibB = "/Users/sheakennedy/Desktop/Elder Desktop/DESKTOP/Drum Kits _ Samples/Waldo/Loops/"
barretInsect = "/Users/sheakennedy/Desktop/Elder Desktop/DESKTOP/Drum Kits _ Samples/Freesound/CC0/Insect/"
barretBird = "/Users/sheakennedy/Desktop/Elder Desktop/DESKTOP/Drum Kits _ Samples/Freesound/CC0/Bird/"
barretBreak = "/Users/sheakennedy/Desktop/Elder Desktop/DESKTOP/Drum Kits _ Samples/QY100 Chops/"
hat = sampleLibB, 1

# === LFO Automation ===
lfo_pan = (line -1, 1, steps: 16).mirror
lfo_cut = (line 70, 100, steps: 8).mirror
lfo_echo_mix = (line 0, 0.9, steps: 16).mirror.map { |v| v**2 }

# === LEVELS ===
inst_bird = 1
inst_fxloop = 1
inst_glitch = 1
inst_insect = 1
inst_hat = 1

# === FX Swell Loop ===
live_loop :glitch_fx_loop do
  with_fx :sound_out_stereo, output: 3 do
    if inst_fxloop > 0
      with_fx :level, amp: inst_fxloop do
        with_fx :ping_pong, feedback: 0.5, mix: 0.4 do
          sample barretBreak, 13, rate: 1, beat_stretch: 8, #2
            onset: (ring 1, 7, 3).tick, release: 0.15
        end
      end
    end
  end
  sleep 8
end

# === Bird Texture Layer 1 ===
live_loop :chirp_pulse do
  with_fx :sound_out_stereo, output: 5 do
    if inst_bird > 0
      with_fx :level, amp: inst_bird do
        with_fx :pan, pan: lfo_pan.tick do
          sample barretBird, 7, rate: 2, onset: (ring 0, 3, 5, 7).choose, release: 0.1
        end
      end
    end
  end
  sleep 0.25
end

# === Bird Texture Layer 2 (Filtered & Faster) ===
live_loop :chirp_filter_spin do
  with_fx :sound_out_stereo, output: 6 do
    if inst_bird > 0
      with_fx :level, amp: inst_bird do
        with_fx :lpf, cutoff: lfo_cut.tick do
          with_fx :pan, pan: lfo_pan.tick do
            sample barretBird, 8, rate: 2, onset: (ring 1, 5, 3, 0).look, release: 0.07
          end
        end
      end
    end
  end
  sleep 0.125
end

# === Ambient Insect Wash ===
live_loop :ambient_insect_whirr do
  with_fx :sound_out_stereo, output: 7 do
    if inst_insect > 0
      with_fx :level, amp: inst_insect do
        with_fx :echo, mix: 0.5, phase: 0.5 do
          sample barretInsect, 3, rate: 4, onset: 1, start: 0, finish: 0.25, release: 0.1
        end
      end
    end
  end
  sleep 4
end

# === Chopped Texture Glitch Pulse ===
live_loop :glitch_pattern do
  with_fx :sound_out_stereo, output: 9 do
    if inst_glitch > 0
      with_fx :level, amp: inst_glitch do
        sample barretBreak, (ring 4, 0).tick, rate: 0.5, beat_stretch: 8,
          start: (ring 0.25, 0.5).look, finish: (ring 0.5, 0.75).look, release: 0.02
      end
    end
  end
  sleep 4
end

# === Trap Hat Variation ===
define :trap_hats do |smp, div, s_rate, e_rate, pan = 0|
  rate_step = (s_rate - e_rate).fdiv(div)
  div.times do
    sample smp, sustain: 0.02, amp: rrand(0.5, 0.6), rate: s_rate, pan: pan
    sleep 0.5 / div
    s_rate -= rate_step
  end
end

live_loop :hat_trickle do
  with_fx :sound_out_stereo, output: 11 do
    if inst_hat > 0
      with_fx :lpf, cutoff: lfo_cut.look do
        with_fx :echo, phase: 0.125, mix: lfo_echo_mix.tick do
          with_fx :slicer, phase: 0.25 do
            trap_hats(
              hat,
              [4, 8, 16, 32].choose,
              rrand(40, 60),
              rrand(60, 40),
              [-0.5, 0, 0.5].choose
            )
          end
        end
      end
    end
  end
  sleep 1
end
