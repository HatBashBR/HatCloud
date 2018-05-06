#!/usr/bin/env ruby
# encoding: UTF-8
require 'net/http'
require 'open-uri'
require 'json'
require 'socket'
require 'optparse'

class String
def black;          "\e[30m#{self}\e[0m" end
def red;            "\e[31m#{self}\e[0m" end
def green;          "\e[32m#{self}\e[0m" end
end
def banner()

puts "\n"
puts"██╗  ██╗ █████╗ ████████╗     ██████╗██╗      ██████╗ ██╗   ██╗██████╗ "
puts"██║  ██║██╔══██╗╚══██╔══╝    ██╔════╝██║     ██╔═══██╗██║   ██║██╔══██╗"
puts"███████║███████║   ██║       ██║     ██║     ██║   ██║██║   ██║██║  ██║"
puts"██╔══██║██╔══██║   ██║       ██║     ██║     ██║   ██║██║   ██║██║  ██║"
puts"██║  ██║██║  ██║   ██║       ╚██████╗███████╗╚██████╔╝╚██████╔╝██████╔╝"
puts"╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝        ╚═════╝╚══════╝ ╚═════╝  ╚═════╝ ╚═════╝ "



puts "Tool for identifying real IP of CloudFlare protected website."
puts "fb.com/hatbashbr/"
puts "github.com/hatbashbr/"

puts "\n"
end

options = {:bypass => nil, :massbypass => nil}
parser = OptionParser.new do|opts|

    opts.banner = "Example: ruby hatcloud.rb -b <your target> or ruby hatcloud.rb --byp <your target>"
    opts.on('-b ','--byp ', 'Discover real IP (bypass CloudFlare)', String)do |bypass|
    options[:bypass]=bypass;
    end

    opts.on('-o', '--out', 'Next release.', String) do |massbypass|
        options[:massbypass]=massbypass

    end

    opts.on('-h', '--help', 'Help') do
        banner()
        puts opts
        puts "Example: ruby hatcloud.rb -b discordapp.com or ruby hatcloud.rb --byp discordapp.com"
        exit
    end
end

parser.parse!


banner()

if options[:bypass].nil?
    puts "Insert URL -b or --byp"
else
	begin
	option = options[:bypass]
	payload = URI ("http://www.crimeflare.us:82/cgi-bin/cfsearch.cgi")
	request = Net::HTTP.post_form(payload, 'cfS' => options[:bypass])

	response =  request.body
	nscheck = /No working nameservers are registered/.match(response)
	if( !nscheck.nil? )
		puts "[-] No valid address - are you sure this is a CloudFlare protected domain?\n"
		exit
	end
	regex = /(\d*\.\d*\.\d*\.\d*)/.match(response)
	if( regex.nil? || regex == "" )
		puts "[-] No valid address - are you sure this is a CloudFlare protected domain?\n"
		exit
	end
rescue
	puts "Fatail Erro !"
end
	ip_real = IPSocket.getaddress (options[:bypass])

	puts "[+] Site analysis: #{option} ".green
	puts "[+] CloudFlare IP is #{ip_real} ".green
	puts "[+] Real IP is #{regex}".green
	target = "http://ipinfo.io/#{regex}/json"
	url = URI(target).read
	json = JSON.parse(url)
	puts "[+] Hostname: ".green + json['hostname'].to_s
	puts "[+] City: ".green  + json['city']
	puts "[+] Region: ".green + json['country']
	puts "[+] Location: ".green + json['loc']
	puts "[+] Organization:".green + json['org']

end
