require './lib/linter_error'
require './lib/file_reader'

describe LinterError do
  let(:lint_error) { LinterError.new('./test_file/test_lint_file.rb') }
  let(:bad_file_name) { LinterError.new('./test_file/BadFileName.rb') }
 
  describe '#check_trailing_space' do
    it 'checks for trailing space' do
      lint_error.check_trailing_space
      expect(lint_error.error[0]).to eql("line:4:18: Error: Trailing whitespace detected. '  def test_method__'")
    end
  end
end