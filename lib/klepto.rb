require 'find'
require 'httpclient'
require 'json'
require 'yaml'

require "klepto/version"
require 'klepto/config'

require 'klepto/source'
require 'klepto/destination'
require 'klepto/destination/tootsie'
require 'klepto/destination/trove'
require 'klepto/synchronizer'

module Klepto
  class << self
    def root
      Dir.pwd
    end
  end
end
