require 'spec_helper'

describe Tym do
  it 'has a version number' do
    expect(Tym::VERSION).not_to be nil
  end

  describe "Tym::execute" do
    let(:img_path) { "./spec/img/" }
    let(:txt_path) { "./spec/txt/" }

    it 'can execute with valid option' do
      input_img = img_path + "before.png"
      input_txt = txt_path + "default.tym"
      output_img = img_path + "before_tym.png"
      validate_img = img_path + "default_output.png"

      Tym::execute(input_img, input_txt) 
      FileUtils::compare_file(output_img, validate_img).should == true
    end

    after do
      FileUtils::rm(Dir.glob(img_path + "*_tym.png"))
    end
  end
end
