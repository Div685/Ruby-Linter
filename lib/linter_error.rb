require_relative 'file_reader.rb'

class LinterError
  attr_reader :check_path, :error
  
  def initialize(file_path)
    @check_path = FileReader.new(file_path)
    @error = []
  end

  def run
    check_trailing_space
    check_class_empty_line
  end

  def check_trailing_space
    @check_path.file_lines.each_with_index do |val, indx|
      if val[-2] == ' ' && !val.strip.empty?
        @error << "line:#{indx + 1}:#{val.size - 1}: Error: Trailing whitespace detected." + " '#{val.gsub(/\s*$/, '_')}'"
        # puts @error
      end
    end
  end

end