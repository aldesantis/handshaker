require "spec_helper"

RSpec.describe Handshaker do
  it "has a version number" do
    expect(Handshaker::VERSION).not_to be nil
  end
end
