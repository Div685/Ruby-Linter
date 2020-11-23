class FileReader
  attr_reader  :err_msg, :file_name, :file_lines, :lines_count
  def initialize(file_name)
    @file_name = file_name
    @err_msg = ''
    begin
        @file_lines = File.readlines(@file_name)
        @lines_count = @file_lines.size
    rescue => exception
        @file_lines = []
        @err_msg = "Check file name or path again!" + exception.to_s
    end
  end

end