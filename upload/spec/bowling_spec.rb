require 'bowling'

describe Bowling, '#scope'  do
  it "reture 0 for all gutter game" do
    bowling = Bowling.new
    20.times { bowling.hit(0) }
    bowling.score.should eq(0)
  end
  it "reture 0 for all gutter game" do
    bowling = Bowling.new
    bowling.score.should eq(1)
  end
end
