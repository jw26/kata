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

    return ' ILL' if ac.include? '?'

    if is_err?(ac.reverse.chars.map(&:to_i))
      ' ERR'
    else
      ''
    end
  end

  def is_ill? c
    c.count('?') > 1
  end

  def is_err? d
    d.each_with_index.map {|x,i| x*(i+1) }.reduce(:+) % 11 != 0
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
      codes = head.zip(*tail).map do |c|
        [ @lookup[c.join] ] + alternatives_for(c.join)
      end

      original = codes.map(&:first)

      if original.count('?') >= 1
        original.join + " ILL"
      else

        results = []

        (0..8).each do |i|
          codes[i] = codes[i].reverse
          while codes[i].count > 1
            c = codes.map(&:first)
            results.push(c.join) unless is_err?(c.reverse)
            codes[i].shift
          end
        end

        if results.count == 1
          results.first
        elsif results.count > 1
          original.join + " AMB " + results.inspect
        else
          original.join
        end
      end
    end
  end
end
