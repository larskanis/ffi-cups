module Cups::Enum
  module IPP
    extend FFI::Library

    Tag = enum [ # ipp_tag_e **** Format tags for attributes ****
      :ipp_tag_cups_invalid, -1,		# Invalid tag name for @link ippTagValue@
      :ipp_tag_zero, 0x00,			# Zero tag - used for separators
      :ipp_tag_operation,			# operation group
      :ipp_tag_job,				# job group
      :ipp_tag_end,				# end-of-attributes
      :ipp_tag_printer,			# printer group
      :ipp_tag_unsupported_group,		# Unsupported attributes group
      :ipp_tag_subscription,			# Subscription group
      :ipp_tag_event_notification,		# Event group
      :ipp_tag_resource,			# resource group @private@
      :ipp_tag_document,			# document group
      :ipp_tag_unsupported_value, 0x10,	# Unsupported value
      :ipp_tag_default,			# default value
      :ipp_tag_unknown,			# unknown value
      :ipp_tag_novalue,			# no-value value
      :ipp_tag_notsettable, 0x15,		# Not-settable value
      :ipp_tag_deleteattr,			# delete-attribute value
      :ipp_tag_admindefine,			# Admin-defined value
      :ipp_tag_integer, 0x21,		# Integer value
      :ipp_tag_boolean,			# boolean value
      :ipp_tag_enum,				# enumeration value
      :ipp_tag_string, 0x30,		# Octet string value
      :ipp_tag_date,				# date/time value
      :ipp_tag_resolution,			# resolution value
      :ipp_tag_range,			# range value
      :ipp_tag_begin_collection,		# Beginning of collection value
      :ipp_tag_textlang,			# text-with-language value
      :ipp_tag_namelang,			# name-with-language value
      :ipp_tag_end_collection,		# End of collection value
      :ipp_tag_text, 0x41,			# Text value
      :ipp_tag_name,				# name value
      :ipp_tag_reserved_string,		# Reserved for future string value @private@
      :ipp_tag_keyword,			# keyword value
      :ipp_tag_uri,				# uri value
      :ipp_tag_urischeme,			# urI scheme value
      :ipp_tag_charset,			# character set value
      :ipp_tag_language,			# language value
      :ipp_tag_mimetype,			# mimE media type value
      :ipp_tag_membername,			# collection member name value
      :ipp_tag_extension, 0x7f,		# Extension point for 32-bit tags
      :ipp_tag_cups_mask, 0x7fffffff,	# Mask for copied attribute values @private@
      # the following expression is used to avoid compiler warnings with +/-0x80000000
      :ipp_tag_cups_const, -0x7fffffff-1	# Bitflag for copied/const attribute values @private@
    ]
  end
end
