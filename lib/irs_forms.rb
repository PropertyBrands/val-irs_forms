require 'prawn'
require 'prawn/layout' # only needed for versions <= 0.6.3
require 'active_support/all'

module IrsForms
end

dir = File.dirname(__FILE__) + '/irs_forms'
require "#{dir}/form"
require "#{dir}/form1099"
require "#{dir}/form1099_misc"
require "#{dir}/form1099_int"
require "#{dir}/form1096"
