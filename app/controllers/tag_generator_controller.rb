	require 'net/https'
	require 'net/http'
class TagGeneratorController < ApplicationController

	def generate_tags
		uri = URI.parse("https://api.thomsonreuters.com/permid/calais")

		post_body = []
		# post_body << "--#{BOUNDARY}\r\n"
		# post_body << "Content-Disposition: form-data; name=\"datafile\"; filename=\"#{File.basename(file)}\"\r\n"
		# post_body << File.read(file)
		# post_body << "\r\n--#{BOUNDARY}--\r\n"

		http = Net::HTTP.new(uri.host, uri.port)
		http.use_ssl = true
		# post_body << "Content-Type: text/xml\r\n"
		# post_body << "outputFormat: xml/rdf\r\n"
		# post_body << "x-ag-access-token: fY7WUM3GGCXHm9ATOhtzhrvlWX8oPo5X\r\n"
		# post_body << "\r\n"
		post_body << "<Document><Body>A pie firm has launched a cricket pie ahead of British Pie Week.\n"+
"Bosses at Pieminister experimented with scorpion and giant water bug pies before settling on cricket pie, which it calls The Hopper.\n"+
"A spokesman for the firm, which was set up in Bristol in 2003, said it was inspired by Mexican street food, where crickets are often erved up to hungry punters.\n"+
"They mixed the crickets with black beans and a ‘rich tomato, chipotle chilli and sour cream sauce’ before finishing it off with fresh lime and coriander.\n"+
"A spokesman said: “Insects could become a regular feature on western menus in the future as they’re a green and sustainable protein source compared to other meats.</Body></Docunent>\n";
		post_body2 = []
		post_body2 << "<Document><Body>"
		post_body2 << params[:desc]
		post_body2 << "</Body></Document>"
		request = Net::HTTP::Post.new(uri.request_uri)
		request.add_field("Content-Type","text/xml")
		request.add_field("outputFormat","application/json")
		#request.add_field("outputFormat","text/n3")		
		request.add_field("x-ag-access-token","fY7WUM3GGCXHm9ATOhtzhrvlWX8oPo5X")
		request.body = post_body2.join
		# request["Content-Type"] = "multipart/form-data, boundary=#{BOUNDARY}"

		render :json => http.request(request).body
	end
	def index
	end

	helper_method :generate_tags
end
