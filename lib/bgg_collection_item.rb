module BoardGameGem
	class BGGCollectionItem < BGGBase

		attr_reader :id, :type, :name, :year_published, :image, :thumbnail, :num_players, :status, :num_plays

		def initialize(xml)
			@id = xml["objectid"].to_i
			@type = xml["subtype"]
			@name = get_string(xml, "name")
			@year_published = get_string(xml, "yearpublished")
			@image = get_string(xml, "image")
			@thumbnail = get_string(xml, "thumbnail")
			@num_players = get_string(xml, "numplayers")
			@status = {
				:own => get_boolean(xml, "status", "own"),
				:prev_owned => get_boolean(xml, "status", "prevowned"),
				:for_trade => get_boolean(xml, "status", "fortrade"),
				:want => get_boolean(xml, "status", "want"),
				:want_to_play => get_boolean(xml, "status", "wanttoplay"),
				:want_to_buy => get_boolean(xml, "status", "wanttobuy"),
				:wishlist => get_boolean(xml, "status", "wishlist"),
				:wishlist_priority => get_integer(xml, "status", "wishlistpriority"),
				:preordered => get_boolean(xml, "status", "preordered"),
				:last_modified => get_datetime(xml, "status", "lastmodified")
			}
			@num_plays = get_integer(xml, "numplays")
		end

		def to_item(statistics = false)
			return BoardGameGem.get_item(@id, statistics)
		end
	end
end