module Cups::Struct
  class PpdChoice < FFI::Struct
    layout :marked, :char,                        # 0 if unselected, 1 if active
      :choice, [:char, Cups::PPD_MAX_NAME],       # Computer key (e.g., "Letter")
      :text, [:char, Cups::PPD_MAX_TEXT],         # Human readable text
      :code, :pointer,                            # Pointer to raw PostScript snippet string
      :option, :pointer                           # Pointer to parent PpdOption struct
  end
end
