# rubocop:disable Lint/NonLocalExitFromIterator

require_relative 'file_reader'
require_relative 'helper'

# LinterError class
class LinterError
  attr_reader :check_path, :error

  def initialize(file_path)
    @check_path = FileReader.new(file_path)
    @error = []
    @helper = Helper.new
    @snake_case = /^[a-z]+_+([:lower:]+)*/
    @camel_case = /^[A-Z]\w+(?:[A-Z]\w+){1,}/
  end

  def run
    check_class_empty_line
    check_trailing_space
    check_double_space
    check_line_limit
    check_file_too_long
    check_bad_method_name
    check_bad_class_name
    check_space_operator
    check_end_file_empty_line
    check_file_name
  end

  def check_trailing_space
    @check_path.file_lines.each_with_index do |val, indx|
      if val[-2] == ' ' && !val.strip.empty?
        @error << "line:#{indx + 1}:#{val.size - 1}: #{@helper.trailing_space} #{val.gsub(/\s*$/, '_')}"
      end
    end
  end

  def check_class_empty_line
    @check_path.file_lines.each_with_index do |val, indx|
      return if val.strip.split(' ').first.eql?('class')

      if @check_path.file_lines[indx].strip.empty?
        @error << "line:#{indx + 1}: #{val.strip.length - (val.strip.length - 1)}: #{@helper.class_line}"
      end
    end
  end

  def check_end_file_empty_line
    if !@check_path.file_lines.last.match?(/\S/) &&
       !@check_path.file_lines[-1].gsub(/(["'])(?:(?=(\\?))\2.)*?\1/, '').match?(/\bend\b/)
      @error << "line:#{@check_path.file_lines.size + 1}: #{@helper.eof_line}"
    end
  end

  def check_double_space
    msg = 'Double spaces detected.'
    regex = /.+\w\s\s.+/
    @check_path.file_lines.each_with_index do |val, indx|
      @error << "line:#{indx + 1} " + msg.to_s if val.match?(regex)
    end
  end

  def check_line_limit
    @check_path.file_lines.each_with_index do |val, indx|
      @error << "line:#{indx + 1}: #{@helper.limit_xter}" if val.size > 80
    end
  end

  def check_bad_method_name
    @check_path.file_lines.each_with_index do |val, indx|
      if val.strip.split(' ').first.eql?('def')
        @error << "line:#{indx + 1}: #{@helper.method_name}" unless val.strip.split(' ')[1].match?(@snake_case)
      end
    end
  end

  def check_bad_class_name
    @check_path.file_lines.each_with_index do |val, indx|
      if val.strip.split(' ').first.eql?('class')
        name_val = val.strip.split(' ')[1]
        @error << "line:#{indx + 1}: #{@helper.class_name}" unless !name_val.match?(/_/) && name_val.match?(@camel_case)
      end
    end
  end

  def check_file_name
    @error << @helper.bad_filename.to_s unless check_path.file_name.split('/')[-1].match?(@snake_case)
  end

  def check_file_too_long
    @error.push("Lint/syntax: #{@helper.file_too_long}") if @check_path.lines_count > 118
  end

  def check_space_operator
    @check_path.file_lines.each_with_index do |val, indx|
      oprs = val.strip.split('')
      next unless oprs.include?('+') || oprs.include?('*')

      @error << "line:#{indx + 1}: #{@helper.space_operator}" unless val.strip.match?(/(?<=\s)\W(?=\s)/)
    end
  end
end

# rubocop:enable Lint/NonLocalExitFromIterator
