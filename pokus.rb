def fake_bin(s)
  s.chars.map {|char| char.to_i < 5 ? 0 : 1}.join
end

p fake_bin("78693635333")