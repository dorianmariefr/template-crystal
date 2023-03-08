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
      Code::Parser.parse("first_name").should eq([{:name => "first_name"}])
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

  context "operations" do
    it "parses 1 + 1" do
      Code::Parser.parse("1 + 1")
    end

    it "parses 1 - 1" do
      Code::Parser.parse("1 - 1")
    end

    it "parses 2 ** 2" do
      Code::Parser.parse("2 ** 2")
    end
  end

  context "groups" do
    it "parses 2 * (1 + 1)" do
      Code::Parser.parse("2 * (1 + 1)")
    end

    it "parses (1 + 1) * 2" do
      Code::Parser.parse("(1 + 1) * 2")
    end
  end

  context "booleans" do
    it "parses true" do
      Code::Parser.parse("true")
    end
  end

  context "lists" do
    it "parses []" do
      Code::Parser.parse("[]")
    end

    it "parses [1]" do
      Code::Parser.parse("[1]")
    end

    it "parses [1, 2, 3]" do
      Code::Parser.parse("[1, 2, 3]")
    end
  end

  context "dictionnaries" do
    it "parses {}" do
      Code::Parser.parse("{}")
    end

    it "parses {a:1}" do
      Code::Parser.parse("{a:1}")
    end

    it "parses { a: 1, b: 2 }" do
      Code::Parser.parse("{ a: 1, b: 2 }")
    end
  end

  context "negations" do
    it "parses !true" do
      Code::Parser.parse("!true").should eq(
        [{:negation => {:operator => "!", :right => {:boolean => "true"}}}]
      )
    end
  end

  context "power" do
    it "parses 2 ** 3" do
      Code::Parser.parse("2 ** 3")
    end
  end

  context "unary minus" do
    it "parses -1" do
      Code::Parser.parse("-1")
    end
  end

  context "ternary" do
    it "parses true ? 1 : 2" do
      Code::Parser.parse("true ? 1 : 2")
    end
  end
end
