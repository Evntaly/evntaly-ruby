require "net/http"
require "json"
require "uri"

module Evntaly
  class SDK
    attr_accessor :base_url, :developer_secret, :project_token, :timeout

    @@tracking_enabled = true

    def initialize(developer_secret:, project_token:)
      @base_url = "https://app.evntaly.com/prod"
      @developer_secret = developer_secret
      @project_token = project_token
    end

    def set_timeout(seconds)
      @timeout = seconds
    end

    def check_limit
      uri = URI("#{base_url}/api/v1/account/check-limits/#{developer_secret}")
      request = Net::HTTP::Get.new(uri, "Content-Type" => "application/json")

      response = send_request(uri, request)

      result = JSON.parse(response.body)
      raise "Unexpected API response format" unless result.key?("limitReached")

      !result["limitReached"]
    rescue => e
      puts "Error checking limit: #{e.message}"
      false
    end

    def track(event)
      unless self.class.tracking_enabled?
        puts "Tracking is disabled. Event not sent."
        return
      end

      unless check_limit
        puts "checkLimit returned false. Event not sent."
        return
      end

      uri = URI("#{base_url}/api/v1/register/event")
      request = Net::HTTP::Post.new(uri)
      request["Content-Type"] = "application/json"
      request["secret"] = developer_secret
      request["pat"] = project_token
      request.body = event.to_json

      response = send_request(uri, request)

      unless response.code.to_i.between?(200, 299)
        raise "Failed to track event: status code #{response.code}"
      end

      puts "✅ Event tracked successfully"
    end

    def identify_user(user)
      uri = URI("#{base_url}/api/v1/register/user")
      request = Net::HTTP::Post.new(uri)
      request["Content-Type"] = "application/json"
      request["secret"] = developer_secret
      request["pat"] = project_token
      request.body = user.to_json

      response = send_request(uri, request)

      unless response.code.to_i.between?(200, 299)
        raise "Failed to identify user: status code #{response.code}"
      end

      puts "✅ User identified successfully"

      true
    end

    def self.tracking_enabled?
      @@tracking_enabled
    end

    def self.disable_tracking
      @@tracking_enabled = false
      puts "🚫 Tracking disabled."
    end

    def self.enable_tracking
      @@tracking_enabled = true
      puts "🟢 Tracking enabled."
    end

    private

    def send_request(uri, request)
      Net::HTTP.start(uri.hostname, uri.port, use_ssl: true, open_timeout: @timeout, read_timeout: @timeout) do |http|
        http.request(request)
      end
    rescue Net::OpenTimeout
      raise "Request timed out (open timeout)"
    rescue Net::ReadTimeout
      raise "Request timed out (read timeout)"
    rescue StandardError => e
      raise "Network error: #{e.message}"
    end
  end
end
