module BoardGameGem
	class BGGItem < BGGBase

		attr_reader :id, :type, :thumbnail, :name, :description, :year_published, :min_players, :max_players,
			:playing_time, :min_playing_time, :max_playing_time, :statistics

		def initialize(xml)
			super
			@id = get_integer("item", "id")
			@type = get_string("item", "type")
			@thumbnail = get_string("thumbnail")
			@name = get_string("name[type='primary']", "value")
			@alternate_names = get_strings("name[type='alternate']", "value")
			@description = get_string("description")
			@year_published = get_integer("yearpublished", "value")
			@min_players = get_integer("minplayers", "value")
			@max_players = get_integer("maxplayers", "value")
			@playing_time = get_integer("playingtime", "value")
			@min_playing_time = get_integer("minplaytime", "value")
			@max_playing_time = get_integer("maxplaytime", "value")
			@statistics = nil
			if !@xml.at_css("statistics").nil?
				@statistics = {}
				@statistics[:user_ratings] = get_integer("usersrated", "value")
				@statistics[:average] = get_float("average", "value")
				@statistics[:bayes] = get_float("bayesaverage", "value")
				@statistics[:ranks] = []
				@xml.css("rank").each do |rank|
					rank_data = {}
					rank_data[:type] = rank["type"]
					rank_data[:name] = rank["name"]
					rank_data[:value] = rank["value"].to_i
					rank_data[:bayes] = rank["bayesaverage"].to_f
					@statistics[:ranks].push(rank_data)
				end
				@statistics[:stddev] = get_float("stddev", "value")
				@statistics[:median] = get_float("median", "value")
				@statistics[:owned] = get_integer("owned", "value")
				@statistics[:trading] = get_integer("trading", "value")
				@statistics[:wanting] = get_integer("wanting", "value")
				@statistics[:wishing] = get_integer("wishing", "value")
				@statistics[:num_comments] = get_integer("numcomments", "value")
				@statistics[:num_weights] = get_integer("numweights", "value")
				@statistics[:average_weight] = get_integer("averageweight", "value")
			end
			
		end
	end
end