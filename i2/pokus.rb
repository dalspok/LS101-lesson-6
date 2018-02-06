def joinor(arr, join_by = ", ", join_last = "or")
  return arr.join(" " + join_last + " ") if arr.size < 3
  arr[0..-2].join(join_by) + join_by + join_last + " "+ arr[-1].to_s
end

p joinor([])
p joinor([1, 2])                   # => "1 or 2"
p joinor([1, 2, 3])                # => "1, 2, or 3"
p joinor([1, 2, 3], '; ')          # => "1; 2; or 3"
p joinor([1, 2, 3], ', ', 'and')   # => "1, 2, and 3"