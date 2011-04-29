class Array
  # Like <tt>Array#detect</tt>, but returns the calculated value
  def grab(&blk)
    result = each do |element|
      value = yield element
      break value if value
    end
    return if result == self
    result
  end
end
