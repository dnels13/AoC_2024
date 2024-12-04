# frozen_string_literal: true

input = File.read('inputs/day1.txt')

list1 = []
list2 = []
input.split("\n").each do |row|
  nums = row.split(' ').map(&:to_i)
  list1 << nums[0]
  list2 << nums[1]
end

list1.sort!
list2.sort!

total_distance = 0
list1.each_with_index do |num, i|
  total_distance += (num - list2[i]).abs
end

puts "PART 1\nTotal distance: #{total_distance}\n\n"


## PART 2

similarity_score = 0
qty_found = 0
list1.each_with_index do |num1, i|
  if list1[i - 1] != num1
    qty_found = 0
    list2.each do |num2|
      qty_found += 1 if num2 == num1
    end
  end
  similarity_score += num1 * qty_found
end

puts "PART 2\nSimilarity score: #{similarity_score}"
