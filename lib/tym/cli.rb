require "optparse"

module Tym
  class Cli
    def self.run(argv)
      params = argv.getopts('', 'overwrite')
      raise if argv[0].nil?
      raise if argv[1].nil?
      Tym.execute(argv[0], argv[1], params['overwrite'])
    end
  end
end

