require "./spec_helper"

describe Marble do
  it "has a version number" do
    Marble::VERSION.should_not be_nil
  end
end
