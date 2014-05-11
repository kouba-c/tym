require 'spec_helper'

describe Tym do
  it 'has a version number' do
    expect(Tym::VERSION).not_to be nil
  end

  describe "Tym::execute" do
    let(:img_path) { "./spec/img/" }
    let(:txt_path) { "./spec/txt/" }

    it 'can execute with default option' do
      input_img = img_path + "before.png"
      input_txt = txt_path + "default.tym"
      output_img = img_path + "before_tym.png"
      validate_img = img_path + "default_output.png"

      Tym::execute(input_img, input_txt) 
      FileUtils::compare_file(output_img, validate_img).should == true
    end

    it 'can execute with multi align and multi color option' do
      input_img = img_path + "before.png"
      input_txt = txt_path + "multialign_multicolor.tym"
      output_img = img_path + "before_tym.png"
      validate_img = img_path + "multialign_multicolor_output.png"

      Tym::execute(input_img, input_txt) 
      FileUtils::compare_file(output_img, validate_img).should == true
    end

    it 'can execute with x position option' do
      input_img = img_path + "before.png"
      input_txt = txt_path + "x_position.tym"
      output_img = img_path + "before_tym.png"
      validate_img = img_path + "x_position_output.png"

      Tym::execute(input_img, input_txt) 
      FileUtils::compare_file(output_img, validate_img).should == true
    end

    after do
      FileUtils::rm(Dir.glob(img_path + "*_tym.png"))
    end
  end


  describe "Tym::Parser" do
    let(:drawer_mock) { Tym::DrawerMock.new }

    describe 'parse text' do
      it '::normal text' do
        text = "NORMAL, string. 012345-6789!"
        Tym::Parser.new(drawer_mock, text.each_line).parse
        (drawer_mock.drawed_texts.join('\n') == text.chomp).should == true
      end

      it '::line enter' do
        text = "" 
        Tym::Parser.new(drawer_mock, text.each_line).parse
        (drawer_mock.drawed_texts.join('\n') == "").should == true
      end

      it '::comment' do
        text = <<-EOS
#this is comment
#
#COLOR=
#ALIGN
        EOS
        Tym::Parser.new(drawer_mock, text.each_line).parse
        (drawer_mock.drawed_texts == []).should == true
      end
    end

    describe 'parse option' do
      describe '::font path' do
        it 'absolute path' do
          text = "#FONTPATH=/file/font/font_file.ttf"
          Tym::Parser.new(drawer_mock, text.each_line).parse
          (drawer_mock.font == "/file/font/font_file.ttf").should == true
        end
        it 'relative path' do
          text = "#FONTPATH=../font_file.ttf"
          Tym::Parser.new(drawer_mock, text.each_line).parse
          (drawer_mock.font == File::expand_path("../font_file.ttf")).should == true
        end
        it 'userhome path' do
          text = "#FONTPATH=~/font_file.ttf"
          Tym::Parser.new(drawer_mock, text.each_line).parse
          (drawer_mock.font == File::expand_path("~/font_file.ttf")).should == true
        end
        it 'empty path' do
          text = "#FONTPATH="
          Tym::Parser.new(drawer_mock, text.each_line).parse
          (drawer_mock.font.nil?).should == true
        end
      end

      describe '::font size' do
        it 'font size = 12' do
          text = "#FONTSIZE=12"
          Tym::Parser.new(drawer_mock, text.each_line).parse
          (drawer_mock.pointsize == 12).should == true
        end
        it 'empty font size' do
          text = "#FONTSIZE="
          Tym::Parser.new(drawer_mock, text.each_line).parse
          (drawer_mock.pointsize.nil?).should == true
        end
      end

      describe '::position x' do
        it 'postion x = 10' do
          text = "#POSITION_X=10"
          Tym::Parser.new(drawer_mock, text.each_line).parse
          (drawer_mock.x == 10).should == true
        end
        it 'postion x = -10' do
          text = "#POSITION_X=-10"
          Tym::Parser.new(drawer_mock, text.each_line).parse
          (drawer_mock.x == -10).should == true
        end
        it 'empty postion x' do
          text = "#POSITION_X="
          Tym::Parser.new(drawer_mock, text.each_line).parse
          (drawer_mock.x.nil?).should == true
        end
        it 'invalid postion x' do
          text = "#POSITION_X=abc123"
          Tym::Parser.new(drawer_mock, text.each_line).parse
          (drawer_mock.x.nil?).should == true
        end
      end

      describe '::position y' do
        it 'postion y = 10' do
          text = "#POSITION_Y=10"
          Tym::Parser.new(drawer_mock, text.each_line).parse
          (drawer_mock.y == 10).should == true
        end
        it 'postion y = -10' do
          text = "#POSITION_Y=-10"
          Tym::Parser.new(drawer_mock, text.each_line).parse
          (drawer_mock.y == -10).should == true
        end
        it 'empty postion y' do
          text = "#POSITION_Y="
          Tym::Parser.new(drawer_mock, text.each_line).parse
          (drawer_mock.y.nil?).should == true
        end
        it 'invalid postion y' do
          text = "#POSITION_Y=abc123"
          Tym::Parser.new(drawer_mock, text.each_line).parse
          (drawer_mock.y.nil?).should == true
        end
      end

      describe '::color' do
        ["White", "WHITE", "white"].each do |input|
          it "color = #{input} -> downcase" do
            text = "#COLOR=#{input}"
            Tym::Parser.new(drawer_mock, text.each_line).parse
            (drawer_mock.fill == "white").should == true
          end
        end

        it 'empty color' do
          text = "#COLOR="
          Tym::Parser.new(drawer_mock, text.each_line).parse
          (drawer_mock.fill.nil?).should == true
        end

        it 'invalid color' do
          text = "#COLOR=WHITE16"
          Tym::Parser.new(drawer_mock, text.each_line).parse
          (drawer_mock.fill.nil?).should == true
        end
      end

      describe '::align' do
        {"CENTER" => Magick::NorthGravity,
         "RIGHT"  => Magick::NorthWestGravity,
         "LEFT"   => Magick::NorthEastGravity}.each do |option, correct|
           it "align = #{option} -> Magick::Gravity" do
             text = "#ALIGN=#{option}"
             Tym::Parser.new(drawer_mock, text.each_line).parse
             (drawer_mock.gravity == correct).should == true
           end
         end

         it "empty align" do
           text = "#ALIGN="
           Tym::Parser.new(drawer_mock, text.each_line).parse
           (drawer_mock.gravity.nil?).should == true
         end

         it "invalid align" do
           text = "#ALIGN=CENTER_RIGHT"
           Tym::Parser.new(drawer_mock, text.each_line).parse
           (drawer_mock.gravity.nil?).should == true
         end

      end
    end


    describe 'parse invalid text' do
      it 'unsupported character' do
        text = "^:*=~"
        proc {
          Tym::Parser.new(drawer_mock, text.each_line).parse
        }.should raise_error(Tym::TymParserException)
      end
      it '"#" dosent put head of line' do
        text = " #COMMNET"
        proc {
          Tym::Parser.new(drawer_mock, text.each_line).parse
        }.should raise_error(Tym::TymParserException)
      end
    end
  end
end
