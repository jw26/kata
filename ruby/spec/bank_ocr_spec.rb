require File.expand_path('../../lib/bank_ocr.rb',__FILE__)

describe BankOcr do

  subject { described_class.new }

  describe 'user story 1' do
    it 'should parse them all mixed up' do
      f = File.expand_path('../fixtures/one-to-nine.txt',__FILE__)

      subject.read_file(f).should == ["123456789"]
    end

    it 'should insert ? for strange looking numbers' do
      f = File.expand_path('../fixtures/one-to-nine-strange.txt',__FILE__)

      subject.read_file(f).should == ["12?45?789 ILL"]
    end
  end

  describe 'user story 3' do
    it 'should check validity' do
      [
        [1,2,3,4,5,6,7,8,9],
        ['?',2,3,4,5,6,7,8,9],
        [0,0,0,0,0,0,0,5,1],
        [7,7,7,7,7,7,1,7,7],
        [9,9,3,9,9,9,9,9,9],
        [9,8,7,6,5,4,3,2,1]
      ].map do |e|
        subject.valid? e
      end.should == [true, false, true, true, true, false]

    end
  end

  pending 'rollback guessing stuff for a bit', 'user story 4' do
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

    pending 'should suggest for single ? ills' do
      f = File.expand_path('../fixtures/e23456789.txt',__FILE__)
      subject.read_file(f).first.should == "123456789"
    end

    it 'should return valid codes' do
      f = File.expand_path('../fixtures/111111111.txt',__FILE__)
      subject.read_file(f).first.should == "711111111"
      f = File.expand_path('../fixtures/888888888.txt',__FILE__)
      subject.read_file(f).first.should include "888888880"
    end
  end
end
