require_relative 'file_reader.rb'
require_relative 'helper.rb'

class LinterError
  attr_reader :check_path, :error
  
  def initialize(file_path)
    @check_path = FileReader.new(file_path)
    @error = []
    @helper = Helper.new
  end

  def run
    check_class_empty_line
    check_trailing_space
    check_end_file_empty_line
    check_double_space
    check_line_limit
    # check_def_empty_line_befor
    # check_def_empty_line
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
    # p @check_path.file_lines[-2]
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
      p val.size
      @error << "line:#{indx + 1} #{@helper.msg_limit_xter}" if val.size > 80
    end
  end
  
end