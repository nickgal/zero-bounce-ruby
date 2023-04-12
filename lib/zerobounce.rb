
# frozen_string_literal: true

require 'zerobounce/error'
require 'zerobounce/version'
require 'zerobounce/request'
require 'zerobounce/response'
require 'zerobounce/configuration'

# Validate an email address with Zerobounce.net
module Zerobounce
  
  API_ROOT_URL      = 'https://api.zerobounce.net/v2'
  BULK_API_ROOT_URL = 'https://bulkapi.zerobounce.net/v2'

  class << self
    attr_writer :configuration

    # Zerobounce configuration
    #
    # @return [Zerobounce::Configuration]
    def configuration
      @configuration ||= Configuration.new
    end
    alias config configuration

    # Configure Zerobounce inside a block.
    #
    # @example
    #   Zerobounce.configure do |config|
    #     config.apikey = 'api-key'
    #   end
    #
    # @yieldparam [Zerobounce::Configuration] config
    def configure
      yield configuration
    end

    # Validates the email address and gets geoip information for an IP if provided.
    #
    # @param [Hash] params
    # @option params [String] :email The email address to validate.
    # @option params [String] :ip_address An IP address, :ipaddress also works.
    # @option params [String] :apikey Use a different API key for this request.
    # @option params [String] :host Use a different host for this request.
    # @option params [String] :headers Use different headers for this request.
    # @return [Zerobounce::Response]
    def validate(email, ip_address=nil)
      params = {email: email, ip_address: ip_address}
      Request.get('validate', params)
    end

    # Get the number of remaining credits on the account.
    #
    # @param [Hash] params
    # @option params [String] :apikey Use a different API key for this request.
    # @option params [String] :host Use a different host for this request.
    # @option params [String] :headers Use different headers for this request.
    # @return [Integer]
    def credits(params={})
      json = Request.get('getcredits', {})
      credits = json[:Credits]
      credits_i = credits.to_i
      return credits_i
    end

    # Convenience method for checking if an email address is valid.
    #
    # @param [String] email
    # @param [Hash] params
    # @return [Boolean]
    # def valid?(email)
    #   # todo:
    #   validate(email: email).valid?
    # end

    # Convenience method for checking if an email address is invalid.
    #
    # @param [String] email
    # @param [Hash] params
    # @return [Boolean]
    # def invalid?(email)
    #   # todo: 
    #   validate(email: email).invalid?
    # end


    def api_usage()
      # todo:
    end

    def validate_batch()
      # todo: 
    end

    def validate_file_send()
      # todo:
    end

    def validate_file_check()
      # todo:
    end

    def validate_file_get()
      # todo:
    end

    def validate_file_delete()
      # todo:
    end

    def scoring_file_send()
      # todo:
    end

    def scoring_file_get()
      # todo:
    end

    def scoring_file_check()
      # todo:
    end

    def scoring_file_delete()
      # todo:
    end

  end
end
