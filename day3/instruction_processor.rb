# frozen_string_literal: true

require 'byebug'
require 'English'

class InstructionProcessor
  VALID_INSTRUCTION_REGEX = /mul\(\d{1,3},\d{1,3}\)/
  ON_OFF_SWITCH_REGEX = /(do\(\)|don't\(\))/

  attr_reader :corrupted_instructions, :switch, :decorrupted_instructions

  def initialize(input_file)
    @corrupted_instructions = File.read(input_file)
    @decorrupted_instructions = []
    @switch = true # Part 2
  end

  def find_operation_instructions
    corrupted_instructions.scan(VALID_INSTRUCTION_REGEX) do
      @decorrupted_instructions << [$LAST_MATCH_INFO, :mul]
    end
  end

  def sum_of_operations
    find_operation_instructions
    decorrupted_instructions.sum { |instruction, _type| execute_operation(instruction[0]) }
  end

  def execute_operation(instruction)
    match_data = instruction.match(/(?<x>\d{1,3}),(?<y>\d{1,3})/)
    match_data[:x].to_i * match_data[:y].to_i
  end

  ## PART 2

  def sum_with_switches
    sum = 0
    corrupted_instructions.scan(ON_OFF_SWITCH_REGEX) { decorrupted_instructions << [$LAST_MATCH_INFO, :on_off_switch] }
    sort_instructions
    decorrupted_instructions.each do |match_data, type|
      case type
      when :on_off_switch then @switch = match_data[0] == 'do()'
      when :mul then sum += execute_operation(match_data[0]) if switch
      end
    end
    sum
  end

  def sort_instructions
    decorrupted_instructions.sort_by! { |match, _| match.begin(0) }
  end
end

input_file = 'inputs/day3.txt'
ip = InstructionProcessor.new(input_file)
part1_solution = ip.sum_of_operations
part2_solution = ip.sum_with_switches

puts "PART 1 SOLUTION: #{part1_solution}\n\n"
puts "PART 2 SOLUTION: #{part2_solution}"
