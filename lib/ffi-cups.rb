require 'ffi'

module Cups
  class Error < RuntimeError
  end
  class FileNotFound < Error
  end
  class JobNotFound < Error
  end
  class ConnectError < Error
  end
  class DestinationNotFound < Error
  end
  class CupsError < Error
  end

  # Custom or default path for libcups.so
  def self.libcups
    if ENV['CUPS_LIB']
      ENV['CUPS_LIB']
    else
      FFI::LibraryPath.new('cups', abi_number: 2)
    end
  end

end

# Constants
require 'ffi-cups/constants'

# Enums
require 'ffi-cups/enum/http/status'
require 'ffi-cups/enum/http/ppd'

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
require 'ffi-cups/struct/ppd_choice'
require 'ffi-cups/struct/ppd_file'
require 'ffi-cups/struct/ppd_option'

# Functions
require 'ffi-cups/ffi/cups'
require 'ffi-cups/ffi/http'
require 'ffi-cups/ffi/array'
require 'ffi-cups/ffi/ipp_attribute'
require 'ffi-cups/ffi/ppd'

# wrappers
require 'ffi-cups/connection'
require 'ffi-cups/job'
require 'ffi-cups/printer'
