require 'geocoder2'
require 'optparse'

module Geocoder2
  class Cli

    def self.run(args, out = STDOUT)
      show_url  = false
      show_json = false

      # remove arguments that are probably coordinates so they are not
      # processed as arguments (eg: -31.96047031,115.84274631)
      coords = args.select{ |i| i.match(/^-\d/) }
      args -= coords

      OptionParser.new{ |opts|
        opts.banner = "Usage:\n    geocode [options] <location>"
        opts.separator "\nOptions: "

        opts.on("-k <key>", "--key <key>",
          "Key for geocoding API (usually optional). Enclose multi-part keys in quotes and separate parts by spaces") do |key|
          if (key_parts = key.split(/\s+/)).size > 1
            Geocoder2.configure(:api_key => key_parts)
          else
            Geocoder2.configure(:api_key => key)
          end
        end

        opts.on("-l <language>", "--language <language>",
          "Language of output (see API docs for valid choices)") do |language|
          Geocoder2.configure(:language => language)
        end

        opts.on("-p <proxy>", "--proxy <proxy>",
          "HTTP proxy server to use (user:pass@host:port)") do |proxy|
          Geocoder2.configure(:http_proxy => proxy)
        end

        opts.on("-s <service>", Geocoder2::Lookup.all_services_except_test, "--service <service>",
          "Geocoding service: #{Geocoder2::Lookup.all_services_except_test * ', '}") do |service|
          Geocoder2.configure(:lookup => service.to_sym)
          Geocoder2.configure(:ip_lookup => service.to_sym)
        end

        opts.on("-t <seconds>", "--timeout <seconds>",
          "Maximum number of seconds to wait for API response") do |timeout|
          Geocoder2.configure(:timeout => timeout.to_i)
        end

        opts.on("-j", "--json", "Print API's raw JSON response") do
          show_json = true
        end

        opts.on("-u", "--url", "Print URL for API query instead of result") do
          show_url = true
        end

        opts.on_tail("-v", "--version", "Print version number") do
          require "geocoder2/version"
          out << "Geocoder2 #{Geocoder2::VERSION}\n"
          exit
        end

        opts.on_tail("-h", "--help", "Print this help") do
          out << "Look up geographic information about a location.\n\n"
          out << opts
          out << "\nCreated and maintained by Alex Reisner, available under the MIT License.\n"
          out << "Report bugs and contribute at http://github.com/alexreisner/geocoder2\n"
          exit
        end
      }.parse!(args)

      # concatenate args with coords that might have been removed
      # before option processing
      query = (args + coords).join(" ")

      if query == ""
        out << "Please specify a location (run `geocode -h` for more info).\n"
        exit 1
      end

      if show_url and show_json
        out << "You can only specify one of -j and -u.\n"
        exit 2
      end

      if show_url
        q = Geocoder2::Query.new(query)
        out << q.url + "\n"
        exit 0
      end

      if show_json
        q = Geocoder2::Query.new(query)
        out << q.lookup.send(:fetch_raw_data, q) + "\n"
        exit 0
      end

      if (result = Geocoder2.search(query).first)
        google = Geocoder2::Lookup.get(:google)
        lines = [
          ["Latitude",       result.latitude],
          ["Longitude",      result.longitude],
          ["Full address",   result.address],
          ["City",           result.city],
          ["State/province", result.state],
          ["Postal code",    result.postal_code],
          ["Country",        result.country],
          ["Google map",     google.map_link_url(result.coordinates)],
        ]
        lines.each do |line|
          out << (line[0] + ": ").ljust(18) + line[1].to_s + "\n"
        end
        exit 0
      else
        out << "Location '#{query}' not found.\n"
        exit 1
      end
    end
  end
end
