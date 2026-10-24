module Cups::Struct
  class PpdOption < FFI::Struct
    layout :conflicted, :char,                    # Conflict status code
      :keyword, [:char, Cups::PPD_MAX_NAME],      # Main option key (e.g., "PageSize")
      :defchoice, [:char, Cups::PPD_MAX_NAME],    # Default option fallback choice
      :text, [:char, Cups::PPD_MAX_TEXT],         # Human readable descriptive flag
      :ui, Cups::Enum::Ppd::Ui,                                  # UI type enum (PickOne, PickMany, etc.)
      :section, Cups::Enum::Ppd::Section,                             # Order dependency section code
      :order, :float,                             # Sequence execution priority
      :num_choices, :int,                         # Choices element scale length
      :choices, :pointer,                         # Points to sequential array block of PpdChoice
      :subgroup, :pointer                         # PpdSubgroup relationship tracking link
  end
end
