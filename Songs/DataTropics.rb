# INITIALIZE MASTER VALUES
use_bpm 40 
use_random_seed 0

# LOAD IN SAMPLE LIBRARIES
sampleLibA = "/DESKTOP/Drum Kits _ Samples/QY100 Chops/" 
sampleLibB = "/DESKTOP/Drum Kits _ Samples/Waldo/Loops/"
hat = "/DESKTOP/Drum Kits _ Samples/Waldo/Loops/", 1

# AUTOMATION
lfo0 = (line 70, 100, inclusive: true, steps: 16).mirror
lfo0r = (line 120, 70, inclusive: true, steps: 16).mirror
lfo1 = (line 0.6, 0.1, inclusive: true, steps: 8).mirror
lfo2 = (line -1, 1, inclusive: true, steps: 16).mirror
lfo3 = (line 70, 120, inclusive: true, steps: 8).mirror
lfo4 = (line 0, 0.9, inclusive: true, steps: 32).mirror.map { |v| v**2 }
lfo5 = (line 80, 120, inclusive: true, steps: 8).mirror
lfo5r = (line 120, 80, inclusive: true, steps: 8).mirror

# MODIFIERS
rate_mod = 1 
pat_mod = 1

# LEVELS
inst0_lvl           = 0.8
inst1_lvl           = 1
inst2_lvl           = 1
inst3_lvl           = 1
inst4_lvl           = 1
inst5_lvl           = 0.8

live_loop :inst0 do
  puts tick
  with_fx :sound_out_stereo, output: 3 do  # ch 3-4
    if(inst0_lvl != 0)
      with_fx :level, amp: inst0_lvl  do
        with_fx :lpf, cutoff: lfo5.look  do
          sample sampleLibA, (ring 4, 0).look, rate: (ring 0.5).look, beat_stretch: 16*rate_mod, start: (ring 0.125, 0.5).look, finish: (ring 0.25, 0.625).look, release: 0.01
        end
      end
    end
  end
  sleep (ring 4).look
end

live_loop :inst1 do
  puts tick
  with_fx :sound_out_stereo, output: 5 do  # ch 5-6
    if(inst1_lvl != 0)
      with_fx :level, amp: inst1_lvl  do
        with_fx :ping_pong, feedback: 0.5, mix: lfo1.look do
          #with_fx :lpf, cutoff: lfo5r.look  do
          with_fx :lpf, cutoff: lfo0.look do
            sample sampleLibB, 7, rate: (ring 4, 8, 8, 8).look, beat_stretch: 32*rate_mod, onset: (ring 1,7,7,9,1,7,7,40).look,  release: 0.01
            #sample sampleLibB, 25, rate: (ring 4).look, beat_stretch: 16*rate_mod, onset: (ring 22, 29).look,  release: 0.01
          end
          #end
        end
      end
    end
  end
  sleep (ring 1*rate_mod, 0.25*rate_mod, 0.5*rate_mod, 0.25*rate_mod).look
end

live_loop :inst2 do
  puts tick
  with_fx :sound_out_stereo, output: 7 do  # ch 7-8
    if(inst2_lvl != 0)
      with_fx :level, amp: inst2_lvl  do
        with_fx :pan, pan: rrand(-0.08, 0.08) do
          with_fx :bitcrusher do
            sample sampleLibB, 7, rate: (ring choose([4,-4]), 8, 8, 8).look, beat_stretch: 32, onset: (ring 1,7,7,9,1,77,40).look,  release: 0.01
          end
          
          #sample sampleLibB, 9, rate: (ring 4, 8, 8, 8).look, beat_stretch: 32, onset: (ring 1,7,7,9,1,7,7,40).look,  release: 0.01
          sample sampleLibB, 19, rate: (ring 1, 2).look, beat_stretch: 16, onset: (ring 7).look,  release: 0.01
        end
      end
    end
  end
  
  sleep (ring 1, 0.25, 0.5, 0.25, 1, 0.25, 0.5, 0.25, 1, 0.25, 0.5, 0.25, 1.25, 0.25, 0.25, 0.25).look
end


live_loop :inst3 do
  puts tick
  with_fx :sound_out_stereo, output: 9 do  # ch 9-10
    if(inst3_lvl != 0)
      # === Settings ===
      sample_path = "/DESKTOP/Drum Kits _ Samples/Freesound/CC0/Bird/", choose([1,6,2])
      total_length = 14.0                        # Length of the sample in seconds
      section_length = 4 * (60.0 / current_bpm)  # 1 measure of 4/4
      fade_time = section_length / 4.0           # 1/4 of section for smooth fade
      buffer = 1                                  # Minimum distance from previous section
      sections = (0..(total_length - section_length)).step(section_length).to_a
      
      # === Last Index Tracking ===
      if !$last_index.is_a?(Integer)
        $last_index = -10
      end
      last_index = $last_index
      
      # === Choose New Section (not same or neighbor) ===
      valid_indices = (0...sections.length).to_a.select do |i|
        (i - last_index).abs > buffer
      end
      
      if valid_indices.empty?
        valid_indices = (0...sections.length).to_a
      end
      
      new_index = valid_indices.choose
      $last_index = new_index
      
      # Calculate Start/Finish Positions (as fractions of sample)
      start_sec = sections[new_index]
      finish_sec = start_sec + section_length
      start_ratio = start_sec / total_length
      finish_ratio = finish_sec / total_length
      
      # FX Randomization
      random_pan = rrand(-0.5, 0.5)
      strong_pingpong = one_in(4)
      delay_mix = strong_pingpong ? 0.6 : 0.2
      delay_phase = strong_pingpong ? 0.375 : 0.25
      
      # Play the Main Sample with Ping Pong and Pan
      with_fx :ping_pong, mix: delay_mix, phase: delay_phase do
        with_fx :pan, pan: random_pan do
          sample sample_path,
            start: start_ratio,
            finish: finish_ratio,
            amp: 1,
            attack: fade_time,
            release: fade_time
        end
      end
      
      # Bitcrushed Slice with HPF
      if one_in(5)
        crush_start_ratio = rrand(start_ratio, finish_ratio - 0.05)
        crush_finish_ratio = crush_start_ratio + 0.05  # Small slice ~5% of sample
        
        with_fx :hpf, cutoff: rrand(90, 131) do
          with_fx :bitcrusher, bits: 7, sample_rate: 8000 do
            sample sample_path,
              start: crush_start_ratio,
              finish: crush_finish_ratio,
              amp: 0.5,
              attack: 0.2,
              release: 0.2,
              pan: rrand(-0.4, 0.4)
          end
        end
      end
    end
  end
  
  sleep 16
end

define :trap_hats do |smp, div, s_rate, e_rate, pan = 0|
  with_sample_defaults sustain: 0.015, release: 0.015 do
    rate_div = (s_rate - e_rate) / div.to_f
    div.times do
      sample smp, sustain: 0.02, amp: rrand(0.5, 0.6), rate: s_rate, pan: pan
      sleep 0.5/div
      s_rate -= rate_div
    end
  end
end

live_loop :inst4 do
  puts tick
  with_fx :sound_out_stereo, output: 11 do  # ch 11-12
    if (inst4_lvl != 0)
      with_fx :lpf, cutoff: lfo5.look  do
        with_fx :echo, phase: choose([0.125]), mix: lfo4.look do
          #with_fx :lpf, cutoff: lfo5.look do
          with_fx :slicer do
            trap_hats(
              hat,
              [1, 4, 32, 6, 128].choose,
              rrand(0, 55),
              rrand(55, 0),
              [-0.7, -0.5, -0.25, 0, 0.25, 0.5, 0.7].choose  # Pan alternates on each call
            )
            #end
          end
        end
        
        trap_hats(
          hat,
          [1, 4, 32, 6, 128].choose,
          rrand(0, 55),
          rrand(55, 0),
          [-0.7, -0.5, -0.25, 0, 0.25, 0.5, 0.7].choose
        )
      end
    else
      sleep 1
    end
  end
end

live_loop :inst5 do
  with_fx :sound_out_stereo, output: 13 do  # ch 13-14
    if(inst5_lvl != 0)
      with_fx :level, amp: inst5_lvl  do
        in_thread do
          doppler_effect
        end
      end
    end
  end
  sleep 8
end

define :doppler_effect do
  sample_path = "/DESKTOP/Drum Kits _ Samples/Waldo/One Shots/", 6
  duration = 3.8  # Now matches loop trigger time
  steps = 128
  
  approach_rates = (1.5..1.0).step((1.0 - 1.5) / steps)
  recede_rates = (1.0..0.7).step((0.7 - 1.0) / steps)
  approach_amps = (0.2..1.0).step((1.0 - 0.2) / steps)
  recede_amps = (1.0..0.2).step((0.2 - 1.0) / steps)
  
  pan_start = rrand(-1.0, 1.0)
  pan_end = -pan_start
  pan_vals = (pan_start..pan_end).step((pan_end - pan_start) / (2 * steps))
  
  with_fx :rbpf, cutoff: 100, mix: 0.9  do
    with_fx :slicer, wave: 1, phase: 1, invert_wave: 1, mix: 0.97 do
      with_fx :krush, cutoff: 100, mix: 0.2 do
        (0...steps).each do |i|
          sample sample_path,
            rate: approach_rates.to_a[i],
            amp: approach_amps.to_a[i],
            pan: pan_vals.to_a[i]
          sleep duration / (2 * steps.to_f)
        end
        
        (0...steps).each do |i|
          sample sample_path,
            rate: recede_rates.to_a[i],
            amp: recede_amps.to_a[i],
            pan: pan_vals.to_a[steps + i]
          sleep duration / (2 * steps.to_f)
        end
      end
    end
  end
end



