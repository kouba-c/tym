require "rmagick"

module Tym
  class Drawer
    attr_accessor :x, :y
    DEFAULT_FONT = ""

    def initialize(image)
      @image = image
      @x = 0
      @y = 0
      @pointsize = 8
      @draw = Magick::Draw.new do 
        self.font = DEFAULT_FONT
        self.fill = 'white'
        self.gravity = Magick::NorthWestGravity
        self.pointsize = 8
      end
    end

    def draw_text(text)
      @draw.annotate(@image,0,0,@x ,@y,text)
      @y += @pointsize 
    end

    def line_enter
      @y += @pointsize
    end

    def pointsize=(size)
      @draw.pointsize = size
      @pointsize = size
    end

    #delegate member setter to Magick::Draw obj
    [:font, :fill, :gravity].each do |m|
      define_method "#{m}=" do |arg|
        self.instance_eval "@draw.#{m} = arg" 
      end
    end
  end
end
