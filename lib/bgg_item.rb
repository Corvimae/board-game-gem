module BoardGameGem
	class BGGItem < BGGBase

		attr_reader :id, :type, :thumbnail, :name, :description, :year_published, :min_players, :max_players,
			:playing_time, :min_playing_time, :max_playing_time, :statistics

		def initialize(xml)
			if !xml.nil?
				@id = get_integer(xml, "item", "id")
				@type = get_string(xml, "item", "type")
				@image = get_string(xml, "image")
				@thumbnail = get_string(xml, "thumbnail")
				@name = get_string(xml, "name[type='primary']", "value")
				@alternate_names = get_strings(xml, "name[type='alternate']", "value")
				@description = get_string(xml, "description")
				@year_published = get_integer(xml, "yearpublished", "value")
				@min_players = get_integer(xml, "minplayers", "value")
				@max_players = get_integer(xml, "maxplayers", "value")
				@playing_time = get_integer(xml, "playingtime", "value")
				@min_playing_time = get_integer(xml, "minplaytime", "value")
				@max_playing_time = get_integer(xml, "maxplaytime", "value")
				@statistics = nil
				if !xml.at_css("statistics").nil?
					@statistics = {}
					@statistics[:user_ratings] = get_integer(xml, "usersrated", "value")
					@statistics[:average] = get_float(xml, "average", "value")
					@statistics[:bayes] = get_float(xml, "bayesaverage", "value")
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
					@statistics[:stddev] = get_float(xml, "stddev", "value")
					@statistics[:median] = get_float(xml, "median", "value")
					@statistics[:owned] = get_integer(xml, "owned", "value")
					@statistics[:trading] = get_integer(xml, "trading", "value")
					@statistics[:wanting] = get_integer(xml, "wanting", "value")
					@statistics[:wishing] = get_integer(xml, "wishing", "value")
					@statistics[:num_comments] = get_integer(xml, "numcomments", "value")
					@statistics[:num_weights] = get_integer(xml, "numweights", "value")
					@statistics[:average_weight] = get_integer(xml, "averageweight", "value")
				else
					@id = 0
					@type = ""
					@image = ""
					@thumbnail = ""
					@name = ""
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
		end
	end
end