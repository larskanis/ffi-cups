module Cups::Enum
  module Ppd
    extend FFI::Library

    # Maps the native ppd_ui_t enum from cups/ppd.h
    Ui = enum(
      :ppd_ui_boolean, # 0 - True or False option
      :ppd_ui_pickone, # 1 - Pick exactly one choice
      :ppd_ui_pickmany # 2 - Pick one or more choices
    )

    # Maps the native ppd_section_t enum from cups/ppd.h
    Section = enum(
      :ppd_order_any,      # 0 - Code can be anywhere in the document
      :ppd_order_jcl,      # 1 - Job Control Language code
      :ppd_order_prolog,   # 2 - PostScript prolog section
      :ppd_order_setup,    # 3 - PostScript document setup section
      :ppd_order_page_setup, # 4 - PostScript page setup section
      :ppd_order_exit      # 5 - PostScript exit server section
    )
  end
end
