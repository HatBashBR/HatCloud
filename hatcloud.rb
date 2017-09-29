#!/usr/bin/env ruby
# encoding: UTF-8
require 'net/http'
require 'open-uri'
require 'json'
require 'socket'
require 'optparse'

def banner()
red = "\033[01;31m"
green = "\033[01;32m"


puts "\n"
puts"██╗  ██╗ █████╗ ████████╗     ██████╗██╗      ██████╗ ██╗   ██╗██████╗ "
puts"██║  ██║██╔══██╗╚══██╔══╝    ██╔════╝██║     ██╔═══██╗██║   ██║██╔══██╗"
puts"███████║███████║   ██║       ██║     ██║     ██║   ██║██║   ██║██║  ██║"
puts"██╔══██║██╔══██║   ██║       ██║     ██║     ██║   ██║██║   ██║██║  ██║"
puts"██║  ██║██║  ██║   ██║       ╚██████╗███████╗╚██████╔╝╚██████╔╝██████╔╝"
puts"╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝        ╚═════╝╚══════╝ ╚═════╝  ╚═════╝ ╚═════╝ "



puts "#{red}Tool for identifying real IP of CloudFlare protected website."
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
	option = options[:bypass]
	payload = URI ("http://www.crimeflare.org/cgi-bin/cfsearch.cgi")
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
		puts "[-] Alternately, maybe crimeflare.org is down? Try it by hand.\n"
		exit
	end
	ip_real = IPSocket.getaddress (options[:bypass])

	puts "[+] Site analysis: #{option} "
	puts "[+] CloudFlare IP is #{ip_real} "
	puts "[+] Real IP is #{regex}"
	target = "http://ipinfo.io/#{regex}/json"
	url = URI(target).read
	json = JSON.parse(url)
	puts "[+] Hostname: " + json['hostname']
	puts "[+] City: "  + json['city']
	puts "[+] Region: " + json['country']
	puts "[+] Location: " + json['loc']
	puts "[+] Organization: " + json['org']

end
