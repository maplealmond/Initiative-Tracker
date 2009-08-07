class Array
  def next
    self.push self.delete self.first
  end
end