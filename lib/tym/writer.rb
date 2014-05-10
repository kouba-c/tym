require "rmagick"
require "fileutils"

module Tym
  class Writer
    DEFAULT_FONT = ""

    def self.execute(image_path, text_path)
      image = Magick::ImageList.new(image_path)
      text = File::open(text_path)

      self.new(image, text) do |writer|
        writer.write
        writer.output(out_path(image_path))
      end
    end

    def self.out_path(image_path)
      File::join(
        File::dirname(image_path),
        File::basename(image_path, ".*") + "_tym" + File::extname(image_path)
      )
    end

    def initialize(image, text_io)
      @image = image
      @text  = text_io
      yield self if block_given?
    end

    def write
      @pointsize = 8
      @y = 0

      @draw = Magick::Draw.new do 
        self.font = DEFAULT_FONT
        self.fill = 'white'
        self.gravity = Magick::NorthWestGravity
        self.pointsize = 8
      end

      @text.each do |line|
        case line.chomp
        when /\A#(.*)\z/
          command_parse($1)
        when /\A([A-z0-9!,. ]+)\z/
          @draw.annotate(@image,0,0,0,@y,$1)
          @y += @pointsize * 2
        when /\A\z/
          @y += @pointsize
        else
          raise "Find Invalid text: #{line}"
        end
      end
    end

    #command = #XXX=YYY
    def command_parse(str)
      case str
      when /^FONTPATH=(.*)$/
        @draw.font = $1
      when /^FONTSIZE=(\d*)$/
        @draw.pointsize = @pointsize = $1.to_i
      when /^POSITION_Y=(\d*)$/
        @y = $1.to_i
      when /^ALIGN=(.*)$/
        align = $1
        case align
        when "CENTER"
          @draw.gravity = Magick::NorthGravity
        when "RIGHT"
          @draw.gravity = Magick::NorthWestGravity
        else
          raise "Find Invalid Parameter. Align = #{$1}"
        end
      else
        #This line is Comment
      end
    end

    def output(path)
      @image.write path
    end
  end
end
