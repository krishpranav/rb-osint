# requires
require 'uri'
require 'net/http'
require 'net/https'
require 'optparse'

class String
    def black;          "\033[30m#{self}\033[0m" end
    def red;            "\033[31m#{self}\033[0m" end
    def green;          "\033[32m#{self}\033[0m" end
    def brown;          "\033[33m#{self}\033[0m" end
    def blue;           "\033[34m#{self}\033[0m" end
    def magenta;        "\033[35m#{self}\033[0m" end
    def cyan;           "\033[36m#{self}\033[0m" end
    def gray;           "\033[37m#{self}\033[0m" end
    def bg_black;       "\033[40m#{self}\033[0m" end
    def bg_red;         "\033[41m#{self}\033[0m" end
    def bg_green;       "\033[42m#{self}\033[0m" end
    def bg_brown;       "\033[43m#{self}\033[0m" end
    def bg_blue;        "\033[44m#{self}\033[0m" end
    def bg_magenta;     "\033[45m#{self}\033[0m" end
    def bg_cyan;        "\033[46m#{self}\033[0m" end
    def bg_gray;        "\033[47m#{self}\033[0m" end
    def bold;           "\033[1m#{self}\033[22m" end
    def reverse_color;  "\033[7m#{self}\033[27m" end
end


options = {}

optparse = OptionParse.new do |opts|
    opts.banner = "Usage: osint.rb --url URL --uri URIS"

    options[:url] = nil
    opts.on('--url URL','Website to test') do |url|
        options[:url] = url
    end

    options[:uri] = nil
    opts.on('--uri URIS', 'URIs to check') do |uri|
        options[:uri] = uri
    end

    options[:debug] = false
    opts.on('-d', '--debug', 'Show debug information') do
        options[:debug] = true
    end

    opts.on('-h', '--help', 'Display this screen') do
        puts opts
        exit
    end
end
optparse.parse!

if options[:url].nil? or options[:uri].nil?
    puts optparse
    exit
end

if options[:debug]
    require 'pry'
    require 'yaml'
end

module OSINT
    class Target
        attr_reader :uri, :ssl

        def initialize(url)
            @uri = URI.parse(url)
            configure_ssl
        end


        def configure_ssl
            @ssl = { :use_ssl => (@url.scheme == 'https') }

            if @ssl[:use_ssl]
                @ssl[:verify_mode] = OpenSSL::SSL::VERIFY_NONE
                @ssl[:ssl_version] = 'SSLv23'
            end
        end

        
