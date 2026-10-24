module Cups
  module Ppd
    extend FFI::Library
    
    ffi_lib(Cups.libcups)

    # @note This function is deprecated and will be removed in a future release of CUPS.
    # Get the PPD file for a printer from the default server.
    # The returned filename is stored in a static buffer and is overwritten with subsequent calls.
    # The caller "owns" the file that is created and must unlink (delete) the returned filename.
    #
    # @param printer [String] The name of the printer destination.
    # @return [String, nil] A local path string pointing to a temporary file containing the PPD data, or nil on failure.
    # @see https://www.cups.org/doc/api-ppd.html CUPS PPD API Reference
    attach_function :cupsGetPPD, [:string], :string

    # @note This function is deprecated and will be removed in a future release of CUPS.
    # Read a PPD file into a parsed structure memory block.
    # Opens the specified local filename context and safely allocates a matching internal configuration handle.
    #
    # @param filename [String] Local filesystem path layout matching target file boundaries.
    # @return [FFI::Pointer] Opaque pointer handle to a newly allocated `ppd_file_t` structure, or NULL if it fails.
    # @see https://www.cups.org/doc/api-ppd.html CUPS PPD API Reference
    attach_function :ppdOpenFile, [:string], :pointer

    # @note This function is deprecated and will be removed in a future release of CUPS.
    # Mark command-line options in a PPD file structure context.
    # Maps IPP attributes like "media", "sides", or "print-quality" directly onto underlying physical PPD options.
    #
    # @param ppd [FFI::Pointer] The parsed `ppd_file_t` structural memory context handler.
    # @param num_options [Integer] Count of command-line items mapped within option pointers array block.
    # @param options [FFI::Pointer] Underlying pointer referencing a flat array of `cups_option_t` values.
    # @return [Integer] Returns 1 if conflicting printer options are uncovered, 0 if mapping succeeds completely.
    # @see https://refspecs.linuxfoundation.org/LSB_3.2.0/LSB-Printing/LSB-Printing/libcups.cupsmarkoptions.1.html Linux API Reference
    attach_function :cupsMarkOptions, [:pointer, :int, :pointer], :int

    # @note This function is deprecated and will be removed in a future release of CUPS.
    # Free all memory space allocations consumed by a loaded PPD file descriptor layout.
    # Once closed, pointers referencing any elements inside this memory context are invalidated.
    #
    # @param ppd [FFI::Pointer] The parsed `ppd_file_t` structure reference pointer returned via `ppdOpenFile`.
    # @return [void]
    # @see https://www.cups.org/doc/api-ppd.html CUPS PPD API Reference
    attach_function :ppdClose, [:pointer], :void

    # @note This function is deprecated and will be removed in a future release of CUPS.
    # Return the very first structured option tracking entry recorded inside the loaded PPD file.
    # Iterates down through the nested array layout of groups into a linear traversal abstraction loop.
    #
    # @param ppd [FFI::Pointer] The parsed `ppd_file_t` structure memory context.
    # @return [FFI::Pointer] A structural pointer highlighting the first `ppd_option_t` allocation, or NULL if empty.
    # @see https://www.cups.org/doc/api-ppd.html CUPS PPD API Reference
    attach_function :ppdFirstOption, [:pointer], :pointer

    # @note This function is deprecated and will be removed in a future release of CUPS.
    # Return the next recorded option tracking layout context inside the active linear traversal loop.
    # Automatically steps into adjacent options or groups tracking across structural array lines.
    #
    # @param ppd [FFI::Pointer] The parsed `ppd_file_t` structure memory context.
    # @return [FFI::Pointer] A structural pointer highlighting the next concurrent `ppd_option_t`, or NULL when finalized.
    # @see https://www.cups.org/doc/api-ppd.html CUPS PPD API Reference
    attach_function :ppdNextOption, [:pointer], :pointer
  end
end
