module BoardGameGem
	class BGGSearchResult < BGGBase

		attr_reader :id, :type, :name, :year_published
		
		def initialize(xml)
			super
			@id = xml["id"].to_i
			@type = xml["type"]
			@name = get_string("name", "value")
			@year_published = get_string("yearpublished", "value")
		end

		def to_item(statistics = false)
			return BoardGameGem.get_item(@id, statistics)
		end
	end
end