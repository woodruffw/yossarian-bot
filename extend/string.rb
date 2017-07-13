class String
  def normalize_whitespace
    self.gsub(/\s+/, ' ')
  end

  def normalize_whitespace!
    self.gsub!(/\s+/, ' ')
  end

  # http://stackoverflow.com/q/9230663
  def unescape_unicode
    self.gsub(/\\u(\h{4})/) { |_| [$1].pack("H*").unpack("n*").pack("U*") }
  end

  def unescape_unicode!
    self.gsub!(/\\u(\h{4})/) { |_| [$1].pack("H*").unpack("n*").pack("U*") }
  end
end
