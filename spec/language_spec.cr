require "./spec_helper"

describe Language do
  context "nothing" do
    it "parses nothing" do
      Code::Parser.parse("nothing").should eq([{:nothing => "nothing"}])
    end

    it "parses null" do
      Code::Parser.parse("null").should eq([{:nothing => "null"}])
    end

    it "parses nil" do
      Code::Parser.parse("nil").should eq([{:nothing => "nil"}])
    end

    it "parses undefined" do
      Code::Parser.parse("undefined").should eq([{:nothing => "undefined"}])
    end
  end

  context "number" do
    it "parses 1" do
      Code::Parser.parse("1")
    end

    it "parses 1.0" do
      Code::Parser.parse("1.0")
    end

    it "parses 10e10" do
      Code::Parser.parse("10e10")
    end
  end

  context "calls" do
    it "parses first_name" do
      Code::Parser.parse("first_name").should eq([{:call => {:name => "first_name"}}])
    end

    it "parses puts(user)" do
      Code::Parser.parse("puts(user)")
    end

    it "parses users.all?(&:valid?)" do
      Code::Parser.parse("users.all?(&:valid?)")
    end

    it "parses users.each do |user| puts(user) end" do
      Code::Parser.parse("users.each do |user| puts(user) end")
    end
  end
end
