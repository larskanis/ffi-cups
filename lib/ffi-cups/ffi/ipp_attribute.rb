module Cups
  module IppAttibute
    extend FFI::Library

    ffi_lib(Cups.libcups)

    typedef Enum::IPP::Tag, :ipp_tag_t
    typedef Enum::IPP::Res, :ipp_res_t

    # Get the number of values in an attribute.
    #
    # @overload ippGetCount(pointer)
    #   @param pointer [Struct::IppAttibute] to ipp_attribute_t struct
    #   @return [Integer]
    attach_function 'ippGetCount', [Struct::IppAttribute.by_ref], :int, blocking: true
    attach_function 'ippGetGroupTag', [Struct::IppAttribute.by_ref], :ipp_tag_t, blocking: true
    attach_function 'ippGetValueTag', [Struct::IppAttribute.by_ref], :ipp_tag_t, blocking: true
    attach_function 'ippGetString', [Struct::IppAttribute.by_ref, :int, :pointer], :string, blocking: true
    attach_function 'ippGetInteger', [Struct::IppAttribute.by_ref, :int], :int, blocking: true

    #     Get a resolution value for an attribute.
    #
    # int ippGetResolution(ipp_attribute_t *attr, int element, int *yres, ipp_res_t *units);
    # Parameters:
    #   attr 	IPP attribute
    #   element 	Value number (0-based)
    #   yres 	Vertical/feed resolution
    #   units 	Units for resolution
    #
    # Return Value: Horizontal/cross feed resolution or 0
    #
    # The element parameter specifies which value to get from 0 to ippGetCount(attr) - 1.
    attach_function 'ippGetResolution', [Struct::IppAttribute.by_ref, :int, :pointer, :pointer], :int, blocking: true

    #     Get a rangeOfInteger value from an attribute.
    #
    # int ippGetRange(ipp_attribute_t *attr, int element, int *uppervalue);
    # Parameters:
    #   attr 	IPP attribute
    #   element 	Value number (0-based)
    #   uppervalue 	Upper value of range
    # Return Value:
    #   Lower value of range or 0
    #
    # The element parameter specifies which value to get from 0 to ippGetCount(attr) - 1.
    attach_function 'ippGetRange', [Struct::IppAttribute.by_ref, :int, :pointer], :int, blocking: true

    #     Return a string corresponding to the enum value.
    #
    # const char *ippEnumString(const char *attrname, int enumvalue);
    # Parameters:
    #   attrname 	Attribute name
    #   enumvalue 	Enum value
    # Return Value: Enum string
    attach_function 'ippEnumString', [:string, :int], :string, blocking: true

    #     Return the value associated with a given enum string.
    #
    # int ippEnumValue(const char *attrname, const char *enumstring);
    # Parameters:
    #   attrname 	Attribute name
    #   enumstring 	Enum string
    # Return Value: Enum value or -1 if unknown
    attach_function 'ippEnumValue', [:string, :string], :int, blocking: true
  end
end
