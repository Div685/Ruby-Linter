class Helper
    attr_reader :line_count_error, :msg_t_space, :msg_c_e_line, :msg_d_e_line, :msg_d_e_line_after, :msg_limit_xter, 
    :msg_file_too_long, :msg_bad_method_name
    def initialize
        @line_count_error = ''
        @msg_t_space = 'Error: Trailing whitespace detected.'
        @msg_c_e_line = 'Extra blank line detected at class body beginning.'
        @msg_d_e_line = 'Extra empty line detected at method body beginning.'
        @msg_d_e_line_after = 'Extra empty line detected between method definition.'
        @msg_limit_xter = '80 characters in one line only'
        @msg_file_too_long = 'File is too long! use only 118 lines per file'
        @msg_bad_method_name = 'use Snake case format for method names'
    end
end