require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

describe Character do
  describe "#nice_hp" do
    it "is (0) for a new character" do
      Character.new.nice_hp.should == "(0)"
    end
    
    it "is the character's 'hp' value wrapped in ( )" do
      @character = Character.new
      @character.hp = 20
      @character.nice_hp.should == "(#{@character.hp})"
    end
  end
  
  describe "#nice_init" do
    it "is the character's 'init' wrapped in [ ]" do
      @character = Character.new
      @character.init = 12
      @character.nice_init.should == "[#{@character.init}]"
    end
  end
  
  describe "#hit" do
    it "applies damage to a new character's 'hp'" do
      @character = Character.new
      @character.hit("10")
      @character.hp.should == 10
    end
    
    it "adds damage to an existing character's 'hp'" do
      @character = Character.new
      @character.hp = 14
      Proc.new { @character.hit("12") }.should change { @character.hp }.by(12)
    end
  end
  
  describe "comparison" do
    before(:each) do
      @character1 = Character.new
      @character2 = Character.new
    end
    
    it "returns a negative number if character1's init is greater than character2's" do
      @character1.init = 16
      @character2.init = 10
      (@character1 <=> @character2).should < 0
    end
    
    it "returns a positive number if character1's init is less than character2's init" do
      @character1.init = 10
      @character2.init = 16
      (@character1 <=> @character2).should > 0
    end
    
    describe "where character1 and character2 have equal inits" do
      before(:each) do
        @character1.init = @character2.init = 10
      end
      
      it "returns a negative number if character1's mod is greater than character2's mod" do
        @character1.mod = "+2"
        @character2.mod = "+1"
        (@character1 <=> @character2).should < 0
      end
      
      it "returns a positive number if character1's mod is less than character2's mod" do
        @character1.mod = "+1"
        @character2.mod = "+2"
        (@character1 <=> @character2).should > 0
      end
    end
  end
end