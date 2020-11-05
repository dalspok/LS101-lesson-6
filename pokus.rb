
def joinor(arr, char_between = ", ", ending_char = "or")
  starting_seq = arr[0..-2].join(char_between)
  "#{starting_seq}#{char_between}#{ending_char} #{arr.last}"
end

p joinor([1, 2])                   # => "1 or 2"
p joinor([1, 2, 3])                # => "1, 2, or 3"
p joinor([1, 2, 3], '; ')          # => "1; 2; or 3"
p joinor([1, 2, 3], ', ', 'and')   # => "1, 2, and 3"