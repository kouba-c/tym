require "fileutils"
require "tym/version"
require "tym/parser"
require "tym/drawer"
require "tym/cli"

module Tym
    def self.execute(image_path, text_path, overwrite=false)
      image = Magick::ImageList.new(image_path)
      text  = File::open(text_path)

      Parser.new(Drawer.new(image), text).parse
      image.write(out_path(image_path, overwrite ? "" : "_tym"))
    end

    def self.out_path(image_path, suffix)
      File::join(
        File::dirname(image_path),
        File::basename(image_path, ".*") + suffix + File::extname(image_path)
      )
    end
end
