class BankOcr

  def initialize
    @lookup = Hash.new('?').merge({
      " _ | ||_|" => 0, "     |  |" => 1,
      " _  _||_ " => 2, " _  _| _|" => 3,
      "   |_|  |" => 4, " _ |_  _|" => 5,
      " _ |_ |_|" => 6, " _   |  |" => 7,
      " _ |_||_|" => 8, " _ |_| _|" => 9
    })
  end

  def status_of ac

    return 'ILL' if ac.include? '?'

    if ac.reverse.chars.each_with_index.map do |i,j|
      i.to_i+((j+2)%10)
    end.reduce(:*) % 11 == 0
      ''
    else
      'ERR'
    end
  end

  def alternatives_for t
    @lookup.values_at(*@lookup.keys.select do |e|
      e.chars.zip(t.chars).count{|i| i.to_set.length > 1} == 1
    end)
  end

  def read_file f
    # for each block of 4 lines
    File.readlines(f).each_slice(4).map do |line|
      # loose the empty line
      line.pop
      # build blocks of 3..
      # ["123456\n","123456\n","123456\n"]
      # becomes
      # [[["1", "2", "3"], ["4", "5", "6"]], [["1", "2", "3"], ["4", "5", "6"]], etc..]
      head, *tail = line.map{|r| r.chomp.chars.each_slice(3) }

      # build strings made up of the zipped blocks of 3..
      # ["123123","456456"]
      # and then look them up
      head.zip(*tail).map(&:join).map{|i| @lookup[i]}.join
    end
  end
end
