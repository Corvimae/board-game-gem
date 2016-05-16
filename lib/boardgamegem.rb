require 'nokogiri'
require 'open-uri'

module BoardGameGem
	API_ROOT = "http://www.boardgamegeek.com/xmlapi2"
	MAX_ATTEMPTS = 10

	def BoardGameGem.get_item(id, statistics = false, options = {})
		options[:id] = id
		options[:stats] = statistics ? 1 : 0
		item = BGGItem.new(BoardGameGem.request_xml("thing", options))
		return item.id == 0 ? nil : item
	end

	def BoardGameGem.get_items(ids, statistics = false, options = {})
		options[:id] = ids.join(",")
		options[:stats] = statistics ? 1 : 0
		item_xml = BoardGameGem.request_xml("thing", options)
		item_list = []
		item_xml.css("item").wrap("<item_data></item_data>")
		item_xml.css("item_data").each do |item_data|
			item = BGGItem.new(item_data)
			item_list.push(item)
		end
		item_list
	end

	def BoardGameGem.get_family(id, options = {})
		options[:id] = id
		family = BGGFamily.new(BoardGameGem.request_xml("family", options))
		return family.id == 0 ? nil : family
	end

	def BoardGameGem.get_user(username, options = {})
		options[:name] = username
		user = BGGUser.new(BoardGameGem.request_xml("user", options))
		return user.id == 0 ? nil : user
	end

	def BoardGameGem.get_collection(username, options = {})
		options[:username] = username
		collection_xml = BoardGameGem.request_xml("collection", options)
		if collection_xml.css("error").length > 0
			return nil
		else
			return BGGCollection.new(collection_xml)
		end
	end

	def BoardGameGem.search(query, options = {})
		options[:query] = query
		xml = BoardGameGem.request_xml("search", options)
		return {
			:total => xml.at_css("items")["total"].to_i,
			:items => xml.css("item").map { |x| BGGSearchResult.new(x) }
		}
	end

	private

	def BoardGameGem.request_xml(method, hash, attempt = 0)
		params = BoardGameGem.hash_to_uri(hash)
		if attempt < MAX_ATTEMPTS
			begin
				open("#{API_ROOT}/#{method}?#{params}") do |file|
					if file.status[0] != "200"
						sleep 0.05
						BoardGameGem.request_xml(method, hash, attempt + 1)
					else
						Nokogiri::XML(file.read)
					end
				end
			rescue
				sleep 0.05
				BoardGameGem.request_xml(method, hash, attempt + 1)
			end
		else
			return nil
		end
	end

	def BoardGameGem.hash_to_uri(hash)
		return hash.to_a.map { |x| "#{x[0]}=#{x[1]}" }.join("&")
	end
end

require 'bgg_base'
require 'bgg_item'
require 'bgg_family'
require 'bgg_user'
require 'bgg_collection'
require 'bgg_collection_item'
require 'bgg_search_result'