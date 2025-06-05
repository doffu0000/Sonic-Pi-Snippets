# BINAURAL MODEL V3_RotatingSound - includes ITD + ILD + delay based on ear spacing (Still doesn't fully model ear shape, pinna effect, and other reverb cues).
# With math for making sound rotate around the listener.
use_bpm 60

EAR_DISTANCE = 0.215       # Average human ear spacing in meters
SPEED_OF_SOUND = 343.0     # Speed of sound in m/s
MIN_DELAY = 0.001         # Minimal allowed delay for :echo phase (> 0)

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
  # Use a tick to get an angle in radians
  angle = tick * (Math::PI / 16)  # Adjust step size for speed of rotation
  
  x = Math.cos(angle)   # Moves from 1 to -1 in cosine wave
  y = Math.sin(angle)   # Moves from 0 to 1 to 0 to -1 in sine wave
  z = 0                 # Ear level
  
  intensity = 1.0
  amp = distance_attenuation(x, y, z, intensity)
  lpf_cutoff_y = cutoff_y(y)
  lpf_cutoff_z = cutoff_z(z)
  
  # Calculate Interaural Time Difference (seconds)
  itd = (EAR_DISTANCE / SPEED_OF_SOUND) * x.abs
  
  # Assign delay times, replace zero delays with MIN_DELAY
  delay_left = x < 0 ? MIN_DELAY : itd
  delay_right = x > 0 ? MIN_DELAY : itd
  delay_left = [delay_left, MIN_DELAY].max
  delay_right = [delay_right, MIN_DELAY].max
  
  # Interaural Level Difference with a power curve for more natural attenuation
  left_amp = amp * (x < 0 ? 1.0 : (1.0 - x)**1.5)
  right_amp = amp * (x > 0 ? 1.0 : (1.0 + x)**1.5)
  
  with_fx :rlpf, cutoff: lpf_cutoff_y, res: 0 do
    with_fx :lpf, cutoff: lpf_cutoff_z do
      
      # Left Ear
      with_fx :echo, phase: delay_left, mix: 0.4, decay: 0.05 do
        with_fx :pan, pan: -1 do
          sample :ambi_choir, amp: left_amp
        end
      end
      
      # Right Ear
      with_fx :echo, phase: delay_right, mix: 0.4, decay: 0.05 do
        with_fx :pan, pan: 1 do
          sample :ambi_choir, amp: right_amp
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
    " delay_L:", delay_left.round(5),
    " delay_R:", delay_right.round(5)
  
  sleep 0.5
end
