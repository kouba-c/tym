require 'spec_helper'

describe Tym do
  it 'has a version number' do
    expect(Tym::VERSION).not_to be nil
  end

  it 'can execute with valid option' do
    Tym::Writer.execute("./spec/img/before.png", "./spec/txt/one_line_center.tym")
  end
end
