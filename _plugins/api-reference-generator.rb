# generate API
require 'open-uri'
require 'openapi3_parser'

openapi_url = "https://github.com/opensearch-project/opensearch-api-specification/releases/download/main-latest/opensearch-openapi.yaml"
openapi_path = "_site/opensearch-openapi.yaml"
File.write(openapi_path, URI.open(openapi_url).read) unless File.exists?(openapi_path)
puts "Loading #{openapi_path} (#{File.size(openapi_path)} byte(s)) ..."

doc = Openapi3Parser.load_file(openapi_path)
puts "Loaded #{openapi_url} with #{doc.paths.size} path(s)."

# doc.paths.keys.each do |key|
#   puts key
# end

operation_groups = doc.paths.map do |path, item| 
  [:get, :head, :put, :post, :delete].map do |method|
    impl = item.send(method)
    next unless impl

    impl.extension('operation-group').split('.').first
  end.compact
end.flatten.compact.uniq

p operation_groups
