module Cups::Struct
  class IppAttribute < FFI::Struct
    # ipp_attribute_t is an opaque pointer
    layout  :dummy_dont_use, :char
  end
end
