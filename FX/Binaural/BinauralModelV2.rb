# BINAURAL MODEL V2 - includes ITD + ILD (this is still not true delay accounting for human ear spacing).
use_bpm 60

define :distance_attenuation do |x, y, z, intensity=1.0|
  d = Math.sqrt(x**2 + y**2 + z**2)
  max_dist = Math.sqrt(3)
  norm_d = d / max_dist
  amp = Math.exp(-norm_d * intensity * 5)
  return [amp, 0.01].max
end

define :cutoff_z do |z|
  if z < 0
    ratio = (z + 1.0001)
    cutoff = 40 + Math.log10(ratio * 10 + 1) * 90
  else
    ratio = (1.0001 - z)
    cutoff = 100 + Math.log10(ratio * 10 + 1) * 30
  end
  return [cutoff, 130.9].min
end

define :cutoff_y do |y|
  if y < 0
    ratio = (y + 1.0001)
    cutoff = 50 + Math.log10(ratio * 10 + 1) * 80
  else
    ratio = (1.0001 - y)
    cutoff = 110 + Math.log10(ratio * 10 + 1) * 20
  end
  return [cutoff, 130.9].min
end

live_loop :random_3d_sample do
  puts tick
  x = rrand(-1.0, 1.0) #(ring -1.0,-0.9375,-0.875,-0.8125,-0.75,-0.6875,-0.625,-0.5625,-0.5,-0.4375,-0.375,-0.3125,-0.25,-0.1875,-0.125, -0.0625,0,0.0625,0.125,0.1875,0.25,0.3125,0.375,0.4375,0.5,0.5625,0.625,0.6875,0.75,0.8125,0.875,0.9375,1.0).mirror.look
  y = rrand(-1.0, 1.0) #(ring -1.0,-0.9375,-0.875,-0.8125,-0.75,-0.6875,-0.625,-0.5625,-0.5,-0.4375,-0.375,-0.3125,-0.25,-0.1875,-0.125, -0.0625,0,0.0625,0.125,0.1875,0.25,0.3125,0.375,0.4375,0.5,0.5625,0.625,0.6875,0.75,0.8125,0.875,0.9375,1.0).mirror.look
  z = rrand(-1.0, 1.0) #(ring -1.0,-0.9375,-0.875,-0.8125,-0.75,-0.6875,-0.625,-0.5625,-0.5,-0.4375,-0.375,-0.3125,-0.25,-0.1875,-0.125, -0.0625,0,0.0625,0.125,0.1875,0.25,0.3125,0.375,0.4375,0.5,0.5625,0.625,0.6875,0.75,0.8125,0.875,0.9375,1.0).mirror.look
  
  intensity = 1.0
  amp = distance_attenuation(x, y, z, intensity)
  lpf_cutoff_y = cutoff_y(y)
  lpf_cutoff_z = cutoff_z(z)
  
  # Interaural Time Difference
  interaural_delay = [x.abs * 0.01, 0.001].max
  delay_left = x < 0 ? 0.001 : interaural_delay
  delay_right = x > 0 ? 0.001 : interaural_delay
  
  # Interaural Level Difference
  left_amp = amp * (1.0 - x) / 2.0
  right_amp = amp * (1.0 + x) / 2.0
  
  with_fx :rlpf, cutoff: lpf_cutoff_y, res: 0 do
    with_fx :lpf, cutoff: lpf_cutoff_z do
      
      # Left Ear
      with_fx :echo, phase: delay_left, mix: 0.4, decay: 0.05 do
        with_fx :pan, pan: -1 do
          sample :elec_beep, amp: left_amp
        end
      end
      
      # Right Ear
      with_fx :echo, phase: delay_right, mix: 0.4, decay: 0.05 do
        with_fx :pan, pan: 1 do
          sample :elec_beep, amp: right_amp
        end
      end
      
    end
  end
  
  print "x:", x.round(2),
    " y:", y.round(2),
    " z:", z.round(2),
    " amp_total:", amp.round(2),
    " left_amp:", left_amp.round(2),
    " right_amp:", right_amp.round(2),
    " cut_y:", lpf_cutoff_y.round(1),
    " cut_z:", lpf_cutoff_z.round(1),
    " delay_L:", delay_left.round(4),
    " delay_R:", delay_right.round(4)
  
  sleep 0.25
end
