require 'nokogiri'
require 'open-uri'

module BoardGameGem
	API_1_ROOT = "https://www.boardgamegeek.com/xmlapi"
	API_2_ROOT = "https://www.boardgamegeek.com/xmlapi2"
	MAX_ATTEMPTS = 10

	def self.get_item(id, statistics = false, api = 2, options = {})
		options[:id] = id
		options[:stats] = statistics ? 1 : 0
		item = BGGItem.new(BoardGameGem.request_xml(api == 2 ? "thing" : "boardgame", options, api), api)
		item.id == 0 ? nil : item
	end

	def self.get_items(ids, statistics = false, api = 2, options = {})
		options[:id] = ids.join(",")
		options[:stats] = statistics ? 1 : 0
		item_list = []
		if api == 2
			path = "thing"
			element = "item"
		else
			path = "boardgame"
			element = "boardgame"
		end

		item_xml = BoardGameGem.request_xml(path, options, api)		
		item_xml.css(element).wrap("<item_data></item_data>")		
		item_xml.css("item_data").each do |item_data|
			item_list.push(BGGItem.new(item_data, api))
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

	def self.request_xml(method, hash, api = 2)
		params = BoardGameGem.hash_to_uri(hash)
		value = BoardGameGem.retryable(tries: MAX_ATTEMPTS, on: OpenURI::HTTPError) do
			if api == 2
				api_path = "#{API_2_ROOT}/#{method}?#{params}"
			else
				api_path = "#{API_1_ROOT}/#{method}/#{hash[:id]}?stats=#{hash[:stats] ? 1 : 0}"
			end
			p api_path
			open(api_path) do |file|
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