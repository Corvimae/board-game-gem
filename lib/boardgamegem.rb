require 'nokogiri'
require 'open-uri'

module BoardGameGem
	API_ROOT = "https://www.boardgamegeek.com/xmlapi2"
	MAX_ATTEMPTS = 10

	def self.get_item(id, statistics = false, options = {})
		options[:id] = id
		options[:stats] = statistics ? 1 : 0
		item = BGGItem.new(BoardGameGem.request_xml("thing", options))
		item.id == 0 ? nil : item
	end

	def self.fetch_items(ids, statistics = false, options = {})
		options[:id] = ids.join(",")
		options[:stats] = statistics ? 1 : 0
		item_xml = BoardGameGem.request_xml("thing", options)
		item_list = []
		item_xml.css("item").wrap("<item_data></item_data>")
		item_xml.css("item_data").each do |item_data|
			item_list.push(BGGItem.new(item_data))
		end
		item_list
	end

	def self.get_family(id, options = {})
		options[:id] = id
		family = BGGFamily.new(BoardGameGem.request_xml("family", options))
		family.id == 0 ? nil : family
	end

	def self.get_user(username, options = {})
		options[:name] = username
		user = BGGUser.new(BoardGameGem.request_xml("user", options))
		user.id == 0 ? nil : user
	end

	def self.get_collection(username, options = {})
		options[:username] = username
		collection_xml = BoardGameGem.request_xml("collection", options)
		if collection_xml.css("error").length > 0
			nil
		else
			BGGCollection.new(collection_xml)
		end
	end

	def self.search(query, options = {})
		options[:query] = query
		xml = BoardGameGem.request_xml("search", options)
		{
			:total => xml.at_css("items")["total"].to_i,
			:items => xml.css("item").map { |x| BGGSearchResult.new(x) }
		}
	end

	private

	def self.request_xml(method, hash, attempt = 0)
		params = BoardGameGem.hash_to_uri(hash)
		value = BoardGameGem.retryable(tries: MAX_ATTEMPTS, on: OpenURI::HTTPError) do
			open("#{API_ROOT}/#{method}?#{params}") do |file|
				if file.status[0] != "200"
					sleep 0.05
					throw OpenURI::HTTPError
				else
					value = Nokogiri::XML(file.read)
				end
			end
		end 
		value
	end

	def self.hash_to_uri(hash)
		return hash.to_a.map { |x| "#{x[0]}=#{x[1]}" }.join("&")
	end

	def self.retryable(options = {}, &block)
	  opts = { :tries => 1, :on => Exception }.merge(options)

	  retry_exception, retries = opts[:on], opts[:tries]

	  begin
	    return yield
	  rescue retry_exception
	    retry if (retries -= 1) > 0
	  end

	  yield
	end
end

require_relative 'bgg_base'
require_relative 'bgg_item'
require_relative 'bgg_family'
require_relative 'bgg_user'
require_relative 'bgg_collection'
require_relative 'bgg_collection_item'
require_relative 'bgg_search_result'