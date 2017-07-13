class Array
  def exclude?(object)
    !include?(object)
  end

  def nonempty?
    !empty?
  end
end
