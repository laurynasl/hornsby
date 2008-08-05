require File.dirname(__FILE__) + '/spec_helper'
require File.dirname(__FILE__) + '/../lib/hornsby'

class Fruit < ActiveRecord::Base
end

Hornsby.scenario(:just_apple) do
  @apple = Fruit.create! :species => 'apple'
end

Hornsby.scenario(:bananas_and_apples => :just_apple) do
  @banana = Fruit.create! :species => 'banana'
end

Hornsby.scenario(:just_orange) do
  @orange = Fruit.create! :species => 'orange'
end

Hornsby.scenario(:fruit => [:just_apple,:just_orange]) do
  @fruit = [@orange,@apple]
end

Hornsby.scenario(:bananas_and_apples_and_oranges => [:bananas_and_apples,:just_orange]) do
  @fruit = [@orange,@apple,@banana]
end

Hornsby.scenario(:bananas_and_more_apples => [:just_apple, :bananas_and_apples]) do
end


# Hornsby.namespace(:pitted_fruit) do
#   scenario(:peach) do
#     @peach = Fruit.create! :species => 'peach'
#   end
#   
#   scenario(:nectarine) do
#     @nectarine = Fruit.create! :species => 'nectarine'
#   end
# end

describe Hornsby, "with just_apple scenario" do
  before do
    Hornsby.build(:just_apple).copy_ivars(self)
  end
  
  it "should create @apple" do
    @apple.should_not be_nil
  end
  
  it "should create Fruit @apple" do
    @apple.should be_instance_of(Fruit)
  end
  
  it "should not create @banana" do
    @banana.should be_nil
  end
  
  it "should have correct species" do
    @apple.species.should == 'apple'
  end
end

describe Hornsby, "with bananas_and_apples scenario" do
  before do
    Hornsby.build(:bananas_and_apples).copy_ivars(self)
  end
  
  it "should have correct @apple species" do
    @apple.species.should == 'apple'
  end
  
  it "should have correct @banana species" do
    @banana.species.should == 'banana'
  end
end

describe Hornsby, "with fruit scenario" do
  before do
    Hornsby.build(:fruit).copy_ivars(self)
  end

  it "should have 2 fruits" do
    @fruit.should have(2).items
  end
  
  it "should have an @apple" do
    @apple.species.should == 'apple'
  end
  
  it "should have an @orange" do
    @orange.species.should == 'orange'
  end
  
  it "should have no @banana" do
    @banana.should be_nil
  end
end

describe Hornsby, "don't repeat completed scenario" do
  before do
    Hornsby.build(:bananas_and_more_apples).copy_ivars(self)
  end

  it "should create only one apple" do
    Fruit.find_all_by_species('apple').size.should == 1
  end
end

=begin
describe Hornsby, "run multiple scenarios" do
  before do
    #Hornsby.build(:bananas_and_more_apples).copy_ivars(self)
    hornsby_scenario :just_apple, :just_orange
  end

  it "should create both apple and orange" do
    @apple.should_not be_nil
    @orange.should_not be_nil
  end
end
=end

#describe Hornsby, "with pitted namespace" do
#  before do
#    Hornsby.build('pitted:peach').copy_ivars(self)
#  end
  
#  it "should have @peach" do
#    @peach.species.should == 'peach'
#  end
#end
