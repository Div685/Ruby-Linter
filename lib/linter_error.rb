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
      @error << "line:#{indx + 2}: #{val.strip.length - (val.strip.length-1)}: #{@helper.msg_c_e_line}" if @check_path.file_lines[indx + 1].strip.empty? #.match?(/^(?:[\t ]*(?:\r?\n|\r))+/)
    end
  end




end