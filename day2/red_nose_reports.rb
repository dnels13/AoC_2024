# frozen_string_literal: true

input_arr = File.read('inputs/day2.txt').split("\n")

count_of_safe_reports = 0
reports = input_arr.collect { |report| report.split(' ').map(&:to_i) }

## PART 1

def safe_report?(report)
  is_safe = true
  sort_direction = report[0] - report[1] <=> 0 # negative = asc, positive = desc
  for i in 0..(report.size - 2) do
    diff = report[i] - report[i + 1]
    is_safe &&= (diff <=> 0) == sort_direction && diff.abs <= 3
    break unless is_safe
  end
end

reports.each do |report|
  count_of_safe_reports += 1 if safe_report?(report)
end

puts "PART 1 SOLUTION:\nNumber of safe reports: #{count_of_safe_reports}\n\n"

## PART 2

def problem_dampener(report)
  report.each_with_index do |_num, i|
    dup = report.dup
    dup.delete_at(i)
    return dup if safe_report?(dup)
  end

  nil # unnecessary, but explicit
end

count_of_safe_reports = 0
reports.each do |report|
  if safe_report?(report)
    count_of_safe_reports += 1
  else
    augmented_report = problem_dampener(report)
    count_of_safe_reports += 1 if augmented_report
  end
end

puts "PART 2 SOLUTION:\nNumber of safe reports (dampened): #{count_of_safe_reports}"
