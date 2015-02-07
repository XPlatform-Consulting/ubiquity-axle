require 'logger'

require 'ubiquity/axle/api/client/http_client'
require 'ubiquity/axle/api/client/requests'

module Ubiquity
  module Axle
    module API
      class Client

        attr_accessor :http_client, :request, :response, :logger

        def initialize(args = { })
          @http_client = HTTPClient.new(args)
          @logger = http_client.logger
        end

        def process_request(request, options = nil)
          @response = nil
          @request = request
          request.client = self unless request.client
          options ||= request.options
          logger.warn { "Request is Missing Required Arguments: #{request.missing_required_arguments.inspect}" } unless request.missing_required_arguments.empty?
          @response = http_client.call_method(request.http_method, { :path => request.path, :query => request.query, :body => request.body }, options)
        end

        def process_request_using_class(request_class, args, options = { })
          @response = nil
          @request = request_class.new(args, options.merge(:client => self))
          process_request(request, options)
        end

        # Exposes HTTP Methods
        # @example http(:get, '/')
        def http(method, *args)
          @request = nil
          @response = http_client.send(method, *args)
          @request = http_client.request
          response
        end

        # ############################################################################################################## #
        # @!group API Endpoints

        def bin_create(args = { }, options = { })
          _request = Requests::BaseRequest.new(
            args,
            {
              :http_method => :post,
              :http_path => 'bins',
              :parameters => [
                { :name => :name, :aliases => [ :bin_name ], :send_in => :body, :required => true }
              ]
            }.merge(options)
          )

          process_request(_request, options)
        end

        def bin_delete(args = { }, options = { })
          _request = Requests::BaseRequest.new(
            args,
            {
              :http_method => :delete,
              :http_path => 'bins/#{arguments[:bin_id]}',
              :parameters => [
                { :name => :bin_id, :send_in => :path, :required => true }
              ]
            }.merge(options)
          )

          process_request(_request, options)
        end

        def bin_get(args = { }, options = { })
          _request = Requests::BaseRequest.new(
            args,
            {
              :http_method => :get,
              :http_path => 'bins/#{arguments[:bin_id]}',
              :parameters => [
                { :name => :bin_id, :send_in => :path, :required => true }
              ]
            }.merge(options)
          )

          process_request(_request, options)
        end

        def bins_get
          http(:get, 'bins')
        end

        def item_comment_create(args = { }, options = { })
          _request = Requests::BaseRequest.new(
            args,
            {
              :http_method => :post,
              :http_path => 'comments',
              :parameters => [
                { :name => :body, :send_in => :body, :required => true },
                { :name => :itemIdentifier, :send_in => :body, :required => true }
              ]
            }.merge(options)
          )

          process_request(_request, options)
        end

        def comment_delete(args = { }, options = { })
          _request = Requests::BaseRequest.new(
            args,
            {
              :http_method => :delete,
              :http_path => 'comments/#{arguments[:comment_id]}',
              :parameters => [
                { :name => :comment_id, :send_in => :path, :required => true }
              ]
            }.merge(options)
          )

          process_request(_request, options)
        end

        def comment_edit(args = { }, options = { })
          _request = Requests::BaseRequest.new(
            args,
            {
              :http_method => :put,
              :http_path => 'comments/#{arguments[:comment_id]}',
              :parameters => [
                { :name => :comment_id, :send_in => :path, :required => true },
                { :name => :body, :send_in => :body, :required => true }
              ]
            }.merge(options)
          )

          process_request(_request, options)
        end
        alias :comment_update :comment_edit

        def file_get(args = { }, options = { })
          _request = Requests::BaseRequest.new(
            args,
            {
              :http_path => 'files/#{arguments[:file_system]}/#{arguments[:file_id]}',
              :parameters => [
                { :name => :file_system, :send_in => :path, :required => true },
                { :name => :file_id, :send_in => :path, :required => true },

                { :name => :include_comments, :send_in => :query },
                { :name => :include_metadata, :send_in => :query },
              ]
            }.merge(options)
          )

          process_request(_request, options)
        end

        def file_items_get(args = { }, options = { })
          _request = Requests::BaseRequest.new(
            args,
            {
              :http_path => 'files/#{arguments[:file_system]}/#{arguments[:file_id]}/items',
              :parameters => [
                { :name => :file_system, :send_in => :path, :required => true },
                { :name => :file_id, :send_in => :path, :required => true },

                { :name => :include_comments, :send_in => :query },
                { :name => :include_metadata, :send_in => :query },
                { :name => :page, :send_in => :query }
              ]
            }.merge(options)
          )

          process_request(_request, options)
        end

        def filesystem_operation_copy(args = { }, options = { })
          _request = Requests::BaseRequest.new(
            args,
            {
              :http_method => :post,
              :http_path => 'filessystemOperations/copy',
              :parameters => [
                { :name => :from, :send_in => :body, :required => true },
                { :name => :to, :send_in => :body, :required => true },
              ]
            }.merge(options)
          )
          _from = _request.arguments[:from]
          _request.arguments[:from] = [*_from] unless _from.is_a?(Array)

          process_request(_request, options)
        end

        def filesystem_operation_folder_create(args = { }, options = { })
          _request = Requests::BaseRequest.new(
            args,
            {
              :http_method => :post,
              :http_path => 'filessystemOperations/createFolder',
              :parameters => [
                { :name => :path, :send_in => :body, :required => true },
              ]
            }.merge(options)
          )

          process_request(_request, options)
        end

        def filesystem_operation_move(args = { }, options = { })
          _request = Requests::BaseRequest.new(
            args,
            {
              :http_method => :post,
              :http_path => 'filessystemOperations/move',
              :parameters => [
                { :name => :from, :send_in => :body, :required => true },
                { :name => :to, :send_in => :body, :required => true },
              ]
            }.merge(options)
          )
          _from = _request.arguments[:from]
          _request.arguments[:from] = [*_from] unless _from.is_a?(Array)

          process_request(_request, options)
        end

        def metadata_edit(args = { }, options = { })
          _request = Requests::BaseRequest.new(
            args,
            {
              :http_method => :put,
              :http_path => 'metadata',
              :parameters => [
                { :name => :itemIdentifier, :send_in => :body, :required => true },
                { :name => :property, :send_in => :body, :required => true },
                { :name => :value, :send_in => :body, :required => true },
              ]
            }.merge(options)
          )
          process_request(_request, options)
        end
        alias :metadata_update :metadata_edit

        def search(args = { }, options = { })
          _request = Requests::BaseRequest.new(
            args,
            {
              :http_path => 'search',
              :parameters => [
                { :name => :q, :send_in => :query, :required => true },
                { :name => :page, :send_in => :query },
                { :name => :includeMetadata, :send_in => :query },
                { :name => :includeComments, :send_in => :query }
              ]
            }.merge(options)
          )
          process_request(_request, options)
        end

        def subclip_create(args = { }, options = { })
          _request = Requests::BaseRequest.new(
            args,
            {
              :http_method => :post,
              :http_path => 'subclips',
              :parameters => [
                { :name => :fileIdentifier, :send_in => :body, :required => true },
                { :name => :binId, :send_in => :body, :required => true },
                { :name => :name, :send_in => :body },
                { :name => :markIn, :send_in => :body },
                { :name => :markOut, :send_in => :body },
              ]
            }.merge(options)
          )
          process_request(_request, options)
        end

        def subclip_get(args = { }, options = { })
          _request = Requests::BaseRequest.new(
            args,
            {
              :http_path => 'subclips/#{arguments[:subclip_id]}',
              :parameters => [
                { :name => :subclip_id, :send_in => :path, :required => true }
              ]
            }.merge(options)
          )
          process_request(_request, options)
        end

        # @!endgroup API Endpoints
        # ############################################################################################################## #

        # Client
      end
    end
  end
end