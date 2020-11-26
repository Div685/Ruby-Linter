require './lib/linter_error'
require './lib/file_reader'

describe LinterError do
  let(:lint_error) { LinterError.new('./test_file/test_lint_file.rb') }
  let(:bad_file_name) { LinterError.new('./test_file/BadFileName.rb') }

  describe '#check_trailing_space' do
    it 'checks for trailing space' do
      lint_error.check_trailing_space
      expect(lint_error.error[0]).to eql('line:4:18: Error: Trailing whitespace detected.   def test_method__')
    end
  end

  describe '#check_class_empty_line' do
    it 'checks for empty line before class keyword' do
      lint_error.check_class_empty_line
      expect(lint_error.error[0]).to eql('line:2: 1: Extra blank line detected at class body beginning.')
    end
  end

  describe '#check_end_file_empty_line' do
    it 'checks for empty line at the end of the file' do
      lint_error.check_end_file_empty_line
      expect(lint_error.error[0]).to eql('line:16: Extra Empty line detected at the end of the file')
    end
  end

  describe '#check_line_limit' do
    it 'checks for maximum 80 characters per line' do
      lint_error.check_line_limit
      expect(lint_error.error[0]).to eql('line:10: 80 characters in one line only')
    end
  end

  describe '#check_bad_method_name' do
    context 'when checks for the method name' do
      it 'checks for the snake case format' do
        lint_error.check_bad_method_name
        expect(lint_error.error[0]).to eql('line:8: use Snake case format for method names.')
      end
    end
  end

  describe '#check_bad_class_name' do
    context 'when checks for the class name' do
      it 'checks for camel case format' do
        bad_file_name.check_bad_class_name
        expect(bad_file_name.error[0]).to eql('line:3: use Camel Case format for class Name.')
      end
    end
  end

  describe '#check_space_operator' do
    it 'checks for space before and after the operators' do
      lint_error.check_space_operator
      expect(lint_error.error[0]).to eql('line:9: Use Space Operator befor and after the character.')
    end
  end

  describe '#check_file_too_long' do
    context 'when line in a file is greater than 118' do
      it 'checks for error' do
        bad_file_name.check_file_too_long
        expect(bad_file_name.error[0]).to eql('Lint/syntax: File is too long! use only 118 lines per file.')
      end
    end
  end

  describe '#check_file_name' do
    context 'when checks for file name' do
      it 'checks for snake case format' do
        bad_file_name.check_file_name
        expect(bad_file_name.error[0]).to eql('Use Snake case format to file name.')
      end
    end
  end

  describe '#check_double_space' do
    it 'checks for double trailing space' do
      bad_file_name.check_double_space
      expect(bad_file_name.error[0]).to eql('line:4 Double spaces detected.')
    end
  end
end
