require File.expand_path('../../lib/bank_ocr.rb',__FILE__)

describe BankOcr do

  subject { described_class.new }

  describe 'user story 1' do
    it 'should parse all the numbers' do
      f = File.expand_path('../fixtures/all-the-numbers.txt',__FILE__)

      subject.read_file(f).should == (0..9).map{|i| i.to_s * 9}
    end

    it 'should parse them all mixed up' do
      f = File.expand_path('../fixtures/one-to-nine.txt',__FILE__)

      subject.read_file(f).should == ["123456789"]
    end

    it 'should insert ? for strange looking numbers' do
      f = File.expand_path('../fixtures/one-to-nine-strange.txt',__FILE__)

      subject.read_file(f).should == ["12?45?789"]
    end
  end

  describe 'user story 3' do
    it 'should check validity' do
      subject.status_of("000000051").should == ""
      subject.status_of("664371495").should == "ERR"
      subject.status_of("66437??95").should == "ILL"
    end
  end

  describe 'user story 4' do
    it 'should generate a set of alternatives' do
      subject.alternatives_for(
        "   "+
        " _|"+
        "  |").should == [1,4]

      subject.alternatives_for(
        "   "+
        "| |"+
        "|_|").should == [0]

      subject.alternatives_for(
        " _ "+
        " _ "+
        " _|").should == [3,5]
    end
  end
end
