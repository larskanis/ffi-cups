module Cups
  class Printer
    attr_reader :name, :options, :connection

    # @param name [String] printer's name
    # @param options [Hash] printer's options
    def initialize(name, options={}, connection=nil)
      @name = name
      @options = options
      @connection = connection
    end

    # Returns the printer state
    # @return [Symbol] printer state from options
    def state
      case options['printer-state']
      when '3' then :idle
      when '4' then :printing
      when '5' then :stopped
      else :unknown
      end
    end

    # Returns the reason for the printer state
    # @return [Array] array of reasons in string format
    def state_reasons
      options['printer-state-reasons'].split(/,/)
    end

    def print_file(filename, title, options={})
      raise "File not found: #{filename}" unless File.exist? filename

      http = @connection.nil? ? nil : @connection.httpConnect2
      job = with_destination(http) do |dest|
        p_options = nil
        num_options = 0
        unless options.empty?
          p_options = FFI::MemoryPointer.new :pointer
          options.each do |k, v|
            # Do not raise invalid options, since cupsCheckDestSupported states valid PPD options as unsupported.
            # unless self.class.cupsCheckDestSupported(dest.to_ptr, k, v, http)
              # raise "Option:#{k} #{v if v} not supported for printer: #{@name}"
            #end
            num_options = Cups.cupsAddOption(k, v, num_options, p_options)
          end
          p_options = p_options.get_pointer(0)
        end

        job_id = Cups.cupsPrintFile2(http, @name, filename, title, num_options, p_options)

        if job_id.zero?
          last_error = Cups.cupsLastErrorString()
          self.class.cupsFreeOptions(num_options, p_options) unless options.empty?
          raise last_error
        end
        #job = Cups::Job.new(job_id, title, @name)
        job = Cups::Job.get_job(job_id, @name, 0, @connection)

        self.class.cupsFreeOptions(num_options, p_options) unless options.empty?
        job
      end
      Cups::Connection.close(http)
      return job
    end

    private def with_destination(http, &block)
      self.class.with_destination(http, @name, &block)
    end

    def self.with_destination(http, name)
      # Get all destinations with cupsGetDests2
      dests = FFI::MemoryPointer.new :pointer
      num_dests = Cups.cupsGetDests2(http, dests)

      # Get the destination from name with cupsGetDest
      p_dest = Cups.cupsGetDest(name, nil, num_dests, dests.get_pointer(0))
      dest = Cups::Struct::Destination.new(p_dest)
      raise "Destination with name: #{name} not found!" if dest.null?
      yield dest
    ensure
      Cups.cupsFreeDests(num_dests, dests.get_pointer(0))
    end

    class IppGetResolutionParams < FFI::Struct
      layout yres: :int, :units => Enum::IPP::Res
    end
    private_constant :IppGetResolutionParams

    # Find the supported value(s) for the given option.
    #
    # If no option is given then the available options are returned.
    #
    # @return [Hash, nil] hash with keys :type and :values or nil when option is not supported
    def find_dest_supported(option = "job-creation-attributes")
      http = @connection.nil? ? nil : @connection.httpConnect2
      with_destination(http) do |dest|
        attr = self.class.cupsFindDestSupported(dest.to_ptr,
                            option, http);
        return nil if attr.null?

        count = IppAttibute.ippGetCount(attr)
        name = IppAttibute.ippGetName(attr)
        type = IppAttibute.ippGetValueTag(attr)
        values = count.times.map do |idx|
          case type
          when :ipp_tag_resolution then
            params = IppGetResolutionParams.new
            xres = IppAttibute.ippGetResolution(attr, idx, params.to_ptr + params.offset_of(:yres), params.to_ptr + params.offset_of(:units))
            if xres != 0
              {xres: xres, yres: params[:yres], units: params[:units]}
            end
          when :ipp_tag_range then
            p_uppervalue = FFI::MemoryPointer.new :int
            low = IppAttibute.ippGetRange(attr, idx, p_uppervalue)
            if low != 0
              {lowervalue: low, uppervalue: p_uppervalue.read_int}
            end
          when :ipp_tag_enum then
            int = IppAttibute.ippGetInteger(attr, idx)
            name = IppAttibute.ippEnumString(option, int)
            {int: int, name: name}
          else
            IppAttibute.ippGetString(attr, idx, nil) || IppAttibute.ippGetInteger(attr, idx)
          end
        end
        { type: type, values: values, name: name }
      end
    end

    # Get all destinations (printer devices)
    # @param connection [Pointer] http pointer from {Cups::Connection#httpConnect2}
    def self.get_destinations(connection=nil)
      pointer = FFI::MemoryPointer.new :pointer
      dests = cupsGetDests2(pointer, connection)
      printers = []
      dests.each do |d|
        printer = Cups::Printer.new(d[:name].dup, printer_options(d), connection)
        printers.push(printer)
      end
      cupsFreeDests(dests.count, pointer)
      return printers
    end

    # Get a destination by name
    # @param name [String] name of the printer
    # @param connection [Pointer] http pointer from {Cups::Connection#httpConnect2}
    # @return [Printer] a printer object
    def self.get_destination(name, connection=nil)
      http = connection.nil? ? nil : connection.httpConnect2
      printer = with_destination(http, name) do |dest|
        Cups::Printer.new(dest[:name].dup, printer_options(dest), connection)
      end
      Cups::Connection.close(http) if http
      return printer
    end

    private
    # Wrapper around {::Cups#cupsGetDests2}
    # @param connection [Pointer] http pointer from {Cups::Connection#httpConnect2}
    # @param pointer [Pointer] pointer to the destinations
    # @return [Hash] hashmap of destination structs
    def self.cupsGetDests2(pointer, connection=nil)
      http = connection.nil? ? nil : connection.httpConnect2
      num_dests = Cups.cupsGetDests2(http, pointer)
      size = Cups::Struct::Destination.size
      destinations = []
      num_dests.times do |i|
        destination = Cups::Struct::Destination.new(pointer.get_pointer(0) + (size * i))
        destinations.push(destination)
      end
      Cups::Connection.close(http) if http
      return destinations
    end

    # Wrapper around {::Cups#cupsCheckDestSupported}
    # @param dest [Pointer] pointer to the destination
    # @param option [String]
    # @param value [String]
    # @param connection [Pointer] http pointer from {Cups::Connection#httpConnect2}
    # @return [Boolean] true if supported, false otherwise
    def self.cupsCheckDestSupported(dest, option, value, connection=nil)
      info = Cups.cupsCopyDestInfo(connection, dest)
      i = Cups.cupsCheckDestSupported(connection, dest, info, option, value)
      return !i.zero?
    end

    def self.cupsFindDestSupported(dest, option, connection=nil)
      info = Cups.cupsCopyDestInfo(connection, dest)
      Cups.cupsFindDestSupported(connection, dest, info, option)
    end

    # Returns a destination's options
    # @param dest [Object] {Cups::Struct::Destination} object
    # @return [Hash] hash of destination' options as {Cups::Struct::Option}
    def self.cups_options(dest)
      size = Cups::Struct::Option.size
      options = []

      dest[:num_options].times do |i|
        option = Cups::Struct::Option.new(dest[:options] + (size * i))
        options.push(option)
      end
      return options
    end

    # Returns a destination's options as hash
    # @param dest [Object] {Cups::Struct::Destination} object
    # @return [Hash] hash of destination' options
    def self.printer_options(dest)
      dest_opts = cups_options(dest)
      options = {}
      dest_opts.each do |o|
        options[o[:name].dup] = o[:value].dup
      end
      return options
    end

    # Wrapper around {::Cups#cupsFreeDests}
    # @param num_dests [Integer]
    # @param pointer [Pointer] pointer to the destinations
    def self.cupsFreeDests(num_dests, pointer)
      Cups.cupsFreeDests(num_dests, pointer.get_pointer(0))
    end

    # Wrapper around {::Cups#cupsFreeOptions}
    # @param num_opts [Integer]
    # @param pointer [Pointer] pointer to the options
    def self.cupsFreeOptions(num_opts, pointer)
      Cups.cupsFreeOptions(num_opts, pointer)
    end
  end
end
