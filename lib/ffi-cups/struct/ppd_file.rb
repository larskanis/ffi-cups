module Cups::Struct
  class PpdFile < FFI::Struct
    # we treat ppd_file_t as an opaque pointer
    layout  :dummy_dont_use, :char
  end
end
