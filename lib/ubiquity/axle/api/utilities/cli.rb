require 'pp'
require 'json'

require 'ubiquity/axle/cli'
require 'ubiquity/axle/api/utilities'

module Ubiquity
  module Axle
    module API
      class Utilities
        class CLI < Ubiquity::Axle::CLI

        def self.define_parameters
          default_http_host_address = Ubiquity::Axle::API::Client::HTTPClient::DEFAULT_HTTP_HOST_ADDRESS
          default_http_host_port = Ubiquity::Axle::API::Client::HTTPClient::DEFAULT_HTTP_HOST_PORT

          argument_parser.on('--host-address HOSTADDRESS', 'The address of the server to communicate with.', "\tdefault: #{default_http_host_address}") { |v| arguments[:http_host_address] = v }
          argument_parser.on('--host-port HOSTPORT', 'The port to use when communicating with the server.', "\tdefault: #{default_http_host_port}") { |v| arguments[:http_host_port] = v }
          argument_parser.on('--access-token ACCESSTOKEN', 'The access token to send to authenticate the request.') { |v| arguments[:access_token] = v }

          argument_parser.on('--method-name METHODNAME', 'The name of the method to call.') { |v| arguments[:method_name] = v }
          argument_parser.on('--method-arguments JSON', 'The arguments to pass when calling the method.') { |v| arguments[:method_arguments] = v }
          argument_parser.on('--pretty-print', 'Will format the output to be more human readable.') { |v| arguments[:pretty_print] = v }

          argument_parser.on('--log-to FILENAME', 'Log file location.', "\tdefault: #{log_to_as_string}") { |v| arguments[:log_to] = v }
          argument_parser.on('--log-level LEVEL', LOGGING_LEVELS.keys, "Logging level. Available Options: #{LOGGING_LEVELS.keys.join(', ')}",
                "\tdefault: #{LOGGING_LEVELS.invert[arguments[:log_level]]}") { |v| arguments[:log_level] = LOGGING_LEVELS[v] }

          argument_parser.on('--[no-]options-file [FILENAME]', 'Path to a file which contains default command line arguments.', "\tdefault: #{arguments[:options_file_path]}" ) { |v| arguments[:options_file_path] = v}
          argument_parser.on_tail('-h', '--help', 'Display this message.') { puts help; exit }
        end

        attr_accessor :logger, :api

        def after_initialize
          initialize_api(arguments)
        end

        def initialize_api(args = { })
          @api = Ubiquity::Axle::API::Utilities.new(args )
        end

        def run(args = arguments, opts = options)
          storage_map = args[:storage_map]
          @api.default_storage_map = JSON.parse(storage_map) if storage_map.is_a?(String)

          metadata_map = args[:metadata_map]
          @api.default_metadata_map = JSON.parse(metadata_map) if metadata_map.is_a?(String)

          method_name = args[:method_name]
          send(method_name, args[:method_arguments], :pretty_print => args[:pretty_print]) if method_name

          self
        end

        def send(method_name, method_arguments, params = {})
          method_name = method_name.to_sym
          logger.debug { "Executing Method: #{method_name}" }

          send_arguments = [ method_name ]

          if method_arguments
            method_arguments = JSON.parse(method_arguments, :symbolize_names => true) if method_arguments.is_a?(String) and method_arguments.start_with?('{', '[')
            send_arguments.concat  method_arguments.is_a?(Array) ? [ *method_arguments ] : [ method_arguments ]
          end
          #puts "Send Arguments: #{send_arguments.inspect}"
          response = api.__send__(*send_arguments)

          # if response.code.to_i.between?(500,599)
          #   puts parsed_response
          #   exit
          # end
          #
          # if ResponseHandler.respond_to?(method_name)
          #   ResponseHandler.client = api
          #   ResponseHandler.response = response
          #   response = ResponseHandler.__send__(*send_arguments)
          # end

          if params[:pretty_print]
            if response.is_a?(String)
              _response_cleaned = response.strip
              if _response_cleaned.start_with?('{', '[')
                puts prettify_json(response)
              else
                #pp response.is_a?(String) ? response : JSON.pretty_generate(response) rescue response
                puts response.is_a?(String) ? response : JSON.pretty_generate(response) rescue response
              end
            else
              pp response.is_a?(String) ? response : JSON.pretty_generate(response) rescue response
            end
          else
            response = JSON.generate(response) if response.is_a?(Hash) or response.is_a?(Array)
            puts response
          end
          # send
        end

        def prettify_json(json)
          JSON.pretty_generate(JSON.parse(json))
        end

        end
      end
    end
  end
end

def cli; @cli ||= Ubiquity::Axle::API::Utilities::CLI end