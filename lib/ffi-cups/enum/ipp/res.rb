module Cups::Enum
  module IPP
    extend FFI::Library

    Res = enum [  # ipp_res_e  # Resolution units
      :ipp_res_per_inch, 3, # Pixels per inch
      :ipp_res_per_cm,  # Pixels per centimeter
    ]
  end
end
