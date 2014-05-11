$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'tym'
require 'fileutils'
require 'hashie'

module Tym
  class DrawerMock < Hashie::Mash
    def drawed_texts
      @drawed_texts ||= []
    end

    def draw_text(text)
      drawed_texts << text
    end
  end
end

