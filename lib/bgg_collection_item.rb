module BoardGameGem
	class BGGCollectionItem < BGGBase

		attr_reader :id, :type, :name, :year_published, :image, :thumbnail, :num_players, :status, :num_plays

		def initialize(xml)
			super
			@id = xml["objectid"].to_i
			@type = xml["subtype"]
			@name = get_string("name")
			@year_published = get_string("yearpublished")
			@image = get_string("image")
			@thumbnail = get_string("thumbnail")
			@num_players = get_string("numplayers")
			@status = {
				:own => get_boolean("status", "own"),
				:prev_owned => get_boolean("status", "prevowned"),
				:for_trade => get_boolean("status", "fortrade"),
				:want => get_boolean("status", "want"),
				:want_to_play => get_boolean("status", "wanttoplay"),
				:want_to_buy => get_boolean("status", "wanttobuy"),
				:wishlist => get_boolean("status", "wishlist"),
				:preordered => get_boolean("status", "preordered"),
				:last_modified => get_datetime("status", "lastmodified")
			}
			@num_plays = get_integer("numplays")
		end

		def to_item(statistics = false)
			return BoardGameGem.get_item(@id, statistics)
		end
	end
end