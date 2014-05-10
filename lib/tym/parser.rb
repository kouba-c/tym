require "rmagick"

module Tym
  class Parser
    def initialize(drawer, text)
      @drawer = drawer
      @text = text
    end

    def parse
      @text.each do |line|
        case line.chomp
        when /\A#(.*)\z/
          command_parse $1
        when /\A([A-z0-9!,. ]+)\z/
          @drawer.draw_text($1)
        when /\A\z/
          @drawer.line_enter
        else
          raise "Find Invalid text: #{line}"
        end
      end
    end

    #command = #XXX=YYY
    def command_parse(str)
      case str
      when /^FONTPATH=(.*)$/
        @drawer.font = $1
      when /^FONTSIZE=(\d*)$/
        @drawer.pointsize = $1.to_i
      when /^POSITION_Y=(\d*)$/
        @drawer.y = $1.to_i
      when /^COLOR=(\d*)$/
        @drawer.color = $1.downcase
      when /^ALIGN=(.*)$/
          @drawer.gravity = {"CENTER" => Magick::NorthGravity,
                             "RIGHT"  => Magick::NorthWestGravity,
                             "LEFT"   => Magick::NorthEastGravity}.fetch $1
      else
        #This line is Comment
      end
    end
  end
end
