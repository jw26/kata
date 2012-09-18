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

  def valid? d
    d.count('?') == 0 and d.each_with_index.map {|x,i| x*(i+1) }.reduce(:+) % 11 != 0
  end

  def prepare_output c
    if c.count('?') > 0
      c.join + " ILL"
    else
      if valid? c
        c.join
      else
        c.join + " ERR"
      end
    end
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
      prepare_output(
        head.zip(*tail).map{|c| @lookup[c.join] })
    end
  end
end
