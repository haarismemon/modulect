require 'net/https'
require 'net/http'

class TagGeneratorController < ApplicationController

	def generate_tags
		uri = URI.parse("https://api.thomsonreuters.com/permid/calais")
		http = Net::HTTP.new(uri.host, uri.port)
		http.use_ssl = true
		post_body = []
		post_body << "<Document><Body>"
		# stip html
		post_body << ActionView::Base.full_sanitizer.sanitize(params[:desc])
		# no strip
		# post_body << params[:desc]
		post_body << "</Body></Document>"
		request = Net::HTTP::Post.new(uri.request_uri)
		request.add_field("Content-Type","text/xml")
		request.add_field("outputFormat","application/json")
		#request.add_field("outputFormat","text/n3")		
		request.add_field("x-ag-access-token","fY7WUM3GGCXHm9ATOhtzhrvlWX8oPo5X")
		request.body = post_body.join
		# request["Content-Type"] = "multipart/form-data, boundary=#{BOUNDARY}"

		render :json => http.request(request).body
	end


	def index
	end

	helper_method :generate_tags
end
