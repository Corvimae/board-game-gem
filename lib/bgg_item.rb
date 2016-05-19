module BoardGameGem
	class BGGItem < BGGBase

		attr_reader :id, :type, :thumbnail, :image, :name, :description, :year_published, :min_players, :max_players,
			:playing_time, :min_playing_time, :max_playing_time, :statistics

		def initialize(xml, api = 2)
			@api = api
			if !xml.nil?
				@id = get_integer(xml, key_for_api("boardgame", "item"), key_for_api("objectid", "id"))
				if api == 2
					@type = get_string(xml, "item", "type")
				else
					if !get_value(xml, "boardgame", "subtypemismatch").nil?
						if !get_value(xml, "videogameplatform").nil?
							@type = "videogame"
						elsif !get_value(xml, "boardgameexpansion").nil?
							@type = "boardgameexpansion"
						end
					else
						@type = "boardgame"
					end
				end
				@image = get_string(xml, "image")
				@thumbnail = get_string(xml, "thumbnail")
				@name = get_string(xml, key_for_api("name", "name[type='primary']"), api_key_value)
				@alternate_names = get_strings(xml, "name[type='alternate']", "value")
				@description = get_string(xml, "description")
				@year_published = get_integer(xml, "yearpublished", api_key_value)
				@min_players = get_integer(xml, "minplayers", api_key_value)
				@max_players = get_integer(xml, "maxplayers", api_key_value)
				@playing_time = get_integer(xml, "playingtime", api_key_value)
				@min_playing_time = get_integer(xml, "minplaytime", api_key_value)
				@max_playing_time = get_integer(xml, "maxplaytime", api_key_value)
				@statistics = nil
				if !xml.at_css("statistics").nil?
					@statistics = {}
					@statistics[:user_ratings] = get_integer(xml, "usersrated", api_key_value)
					@statistics[:average] = get_float(xml, "average", api_key_value)
					@statistics[:bayes] = get_float(xml, "bayesaverage", api_key_value)
					@statistics[:ranks] = []
					xml.css("rank").each do |rank|
						rank_data = {}
						rank_data[:type] = rank["type"]
						rank_data[:name] = rank["name"]
						rank_data[:friendly_name] = rank["friendlyname"]
						rank_data[:value] = rank["value"].to_i
						rank_data[:bayes] = rank["bayesaverage"].to_f
						@statistics[:ranks].push(rank_data)
					end
					@statistics[:stddev] = get_float(xml, "stddev", api_key_value)
					@statistics[:median] = get_float(xml, "median", api_key_value)
					@statistics[:owned] = get_integer(xml, "owned", api_key_value)
					@statistics[:trading] = get_integer(xml, "trading", api_key_value)
					@statistics[:wanting] = get_integer(xml, "wanting", api_key_value)
					@statistics[:wishing] = get_integer(xml, "wishing", api_key_value)
					@statistics[:num_comments] = get_integer(xml, "numcomments", api_key_value)
					@statistics[:num_weights] = get_integer(xml, "numweights", api_key_value)
					@statistics[:average_weight] = get_integer(xml, "averageweight", api_key_value)
				end
			else
				@id = 0
				@type = ""
				@image = ""
				@thumbnail = ""
				@name = "Data pending..."
				@alternate_names = []
				@description = ""
				@year_published = -1
				@min_players = -1
				@max_players = -1
				@playing_time = -1
				@min_playing_time = -1
				@max_playing_time = -1
				@statistics = nil
			end
		end

		def get_user_collection_data(username)
			return BoardGameGem.get_collection(username, id: @id)
		end
	end
end