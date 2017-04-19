def is_prime?(num)
  counter = 2
  while counter < num
    return false if num % counter == 0
    counter += 1
  end
  true
end

def prime_array(arr)
  arr.select { |num| is_prime?(num)  }
end

def how_many_primes(arr)
  prime_array(arr).count
end

p how_many_primes [2,3,4,5]

