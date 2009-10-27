# coding: utf-8

#==============================================================================#
# $Id: test_helper.rb 110 2009-02-09 07:20:20Z yuyakato $
#==============================================================================#

require "test/unit"
require "rubygems"

begin
  require "redgreen"
rescue LoadError
  # nop
end

begin
  require "win32console" if /win32/ =~ RUBY_PLATFORM
rescue LoadError
  # nop
end

$:.unshift(File.dirname(__FILE__) + "/../lib")
require "kagemusha"

#==============================================================================#
#==============================================================================#
