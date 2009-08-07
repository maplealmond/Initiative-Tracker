require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

describe Array do
  
  before(:each) do
    @array = [:a, :b, :c]
  end
  
  describe "#next" do
    it "moves the front element of the array to the back" do
      @array.next
      @array[2].should == :a
    end
    
    it "leaves the other elements of the array in the same order" do
      array2 = @array.clone
      @array.next
      @array[0..1].should == array2[1..2]
    end
    
    it "returns the re-ordered array" do
      @array.next.should == [:b, :c, :a]
    end
  end
end