# Helper class for linter_error file
class Helper
  attr_reader :trailing_space, :class_line, :limit_xter,
              :file_too_long, :method_name,
              :class_name, :eof_line,
              :bad_filename, :space_operator

  def initialize
    @trailing_space = 'Error: Trailing whitespace detected.'
    @class_line = 'Extra blank line detected at class body beginning.'
    @eof_line = 'Extra Empty line detected at the end of the file'
    @limit_xter = '80 characters in one line only'
    @file_too_long = 'File is too long! use only 118 lines per file.'
    @method_name = 'use Snake case format for method names.'
    @class_name = 'use Camel Case format for class Name.'
    @bad_filename = 'Use Snake case format to file name.'
    @space_operator = 'Use Space Operator befor and after the character.'
  end
end
