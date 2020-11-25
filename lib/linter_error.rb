require_relative 'file_reader.rb'
require_relative 'helper.rb'

class LinterError
  attr_reader :check_path, :error
  
  def initialize(file_path)
    @check_path = FileReader.new(file_path)
    @error = []
    @helper = Helper.new
    @snake_case = /^[a-z]+_+([:lower:]+)*/ #/^[[a-z][[:lower:]]_.?!]+$/.freeze
    @camel_case = /(?<!^)[A-Z]/
  end

  def run
    check_class_empty_line
    check_trailing_space
    check_end_file_empty_line
    check_double_space
    check_line_limit
    check_file_too_long
    check_bad_method_name
    check_bad_class_name
  end

  def check_trailing_space
    @check_path.file_lines.each_with_index do |val, indx|
      if val[-2] == ' ' && !val.strip.empty?
        @error << "line:#{indx + 1}:#{val.size - 1}: #{@helper.msg_t_space}" + " '#{val.gsub(/\s*$/, '_')}'"
      end
    end
  end

  def check_class_empty_line
    @check_path.file_lines.each_with_index do |val, indx|
      return if val.strip.split(' ').first.eql?('class')
      @error << "line:#{indx + 1}: #{val.strip.length - (val.strip.length-1)}: #{@helper.msg_c_e_line}" if @check_path.file_lines[indx].strip.empty? #.match?(/^(?:[\t ]*(?:\r?\n|\r))+/)
    end
  end

  def check_end_file_empty_line
    if !@check_path.file_lines.last.match?(/\S/) &&
      !@check_path.file_lines[-1].gsub(/(["'])(?:(?=(\\?))\2.)*?\1/, '').match?(/\bend\b/)
     @error << "line:#{@check_path.file_lines.size + 1}: #{@helper.msg_e_line_EOF}"
    end
  end

  def check_double_space
    msg = 'Double spaces detected.'
    regex = /.+[\w]\s\s.+/
    @check_path.file_lines.each_with_index do |val, indx|
      @error << "line:#{indx + 1} " + msg.to_s if val.match?(regex)
    end
  end

  def check_line_limit
    @check_path.file_lines.each_with_index do |val, indx|
      @error << "line:#{indx + 1}: #{@helper.msg_limit_xter}" if val.size > 80
    end
  end

  def check_bad_method_name
    @check_path.file_lines.each_with_index do |val, indx|
      if val.strip.split(' ').first.eql?('def') 
        @error << "line:#{indx + 1}: #{@helper.msg_bad_method_name}" unless val.strip.split(' ')[1].match?(@snake_case)
      end
    end
  end

  def check_bad_class_name
    @check_path.file_lines.each_with_index do |val, indx|
      if val.strip.split(' ').first.eql?('class') 
        @error << "line:#{indx + 1}: #{@helper.msg_bad_class_name}" unless val.strip.split(' ')[1].match?(@camel_case)
      end
    end
  end

  def check_file_too_long
    @error << "Lint/syntax: #{@helper.msg_file_too_long}" if @check_path.lines_count > 118
  end

end