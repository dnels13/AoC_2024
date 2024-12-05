# frozen_string_literal: true

require 'byebug'

class InstructionProcessor
  VALID_INSTRUCTION_REGEX = /mul\(\d{1,3},\d{1,3}\)/
  ON_SWITCH_REGEX = /do\(\)/
  OFF_SWITCH_REGEX = /don't\(\)/

  attr_reader :corrupted_instructions, :switch

  def initialize(input_file)
    @corrupted_instructions = File.read(input_file)
    @switch = true # Part 2
  end

  def operation_instructions
    corrupted_instructions.scan(VALID_INSTRUCTION_REGEX)
  end

  def sum_of_operations
    operation_instructions.sum { |instruction| execute_operation(instruction) }
  end

  def execute_operation(instruction)
    match_data = instruction.match(/(?<x>\d{1,3}),(?<y>\d{1,3})/)
    match_data[:x].to_i * match_data[:y].to_i
  end

  ## PART 2

  def sum_active_operations
    activated_operations.sum { |instruction| execute_operation(instruction) }
  end

  def on_switches
    @on_switches ||= corrupted_instructions.enum_for(:scan, ON_SWITCH_REGEX).map { Regexp.last_match.begin(0) }
  end

  def off_switches
    @off_switches ||= corrupted_instructions.enum_for(:scan, OFF_SWITCH_REGEX).map { Regexp.last_match.begin(0) }
  end

  def activated_operations
    activated_operations = []
    next_on_switch = on_switches.shift || corrupted_instructions.size # if 0, all switches have been exhausted
    next_off_switch = off_switches.shift || corrupted_instructions.size # if size, all switches have been exhausted
    next_operation_index = 0
    while next_operation_index < operation_instructions.size
      # byebug
      operation_location = corrupted_instructions.index(operation_instructions[next_operation_index])
      next_instruction = [next_on_switch, next_off_switch, operation_location].min
      if next_instruction == next_on_switch
        @switch = true
        next_on_switch = on_switches.shift || corrupted_instructions.size
      elsif next_instruction == next_off_switch
        @switch = false
        next_off_switch = off_switches.shift || corrupted_instructions.size
      elsif switch
        activated_operations << operation_instructions[next_operation_index]
        next_operation_index += 1
      end
    end
    activated_operations
  end
end

input_file = 'inputs/day3.txt'
ip = InstructionProcessor.new(input_file)
part1_solution = ip.sum_of_operations
part2_solution = ip.sum_active_operations

puts "PART 1 SOLUTION: #{part1_solution}\n\n"
puts "PART 2 SOLUTION: #{part2_solution}"