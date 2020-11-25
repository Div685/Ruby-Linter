# rubocop:disable all

class BadFileName
  def test_method 
    puts "Test method"
  end
  
  def Test_abc
    puts "Test Method Test Method Test Method Test Method Test Method Test Method Test Method Test Method"
  end
end