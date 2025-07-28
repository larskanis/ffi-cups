require 'ffi'

module Cups

  # Custom or default path for libcups.so
  def self.libcups
    if ENV['CUPS_LIB']
      ENV['CUPS_LIB']
    else
      'cups'
    end
  end

end

# Constants
require 'ffi-cups/constants'

# Enums
require 'ffi-cups/enum/http/status'
# IPP
require 'ffi-cups/enum/ipp/status'
require 'ffi-cups/enum/ipp/job_state'
require 'ffi-cups/enum/ipp/res'
require 'ffi-cups/enum/ipp/tag'

# Structs
require 'ffi-cups/struct/option'
require 'ffi-cups/struct/destination'
require 'ffi-cups/struct/job'
require 'ffi-cups/struct/ipp_attribute'

# Functions
require 'ffi-cups/ffi/cups'
require 'ffi-cups/ffi/http'
require 'ffi-cups/ffi/array'
require 'ffi-cups/ffi/ipp_attribute'

# wrappers
require 'ffi-cups/connection'
require 'ffi-cups/job'
require 'ffi-cups/printer'
