module BoardGameGem
	class BGGBase
		def initialize(xml)
			@xml = xml
		end

		def to_s
			return instance_variables.map{|ivar| "#{ivar} => #{instance_variable_get ivar}" }
		end

		protected

		def get_value(path, key = nil)
			item = @xml.at_css(path)
			if item.nil?
				return nil
			end
			if key.nil?
				return item.content
			else
				return item[key]
			end
		end

		def get_values(path, key = nil)
			results = []
			@xml.css(path).each do |item|
				if key.nil?
					results.push(item.content)
				else
					results.push(item[key])
				end
			end
			return results
		end

		def get_boolean(path, key = nil)
			return get_integer(path, key) == 1 rescue nil
		end

		def get_integer(path, key = nil)
			return get_value(path, key).to_i rescue nil
		end

		def get_integers(path, key = nil)
			return get_values(path, key).map {|x| x.to_i } rescue nil
		end

		def get_string(path, key = nil)
			return get_value(path, key).to_s rescue nil
		end

		def get_strings(path, key = nil)
			return get_values(path, key).map {|x| x.to_s } rescue nil
		end

		def get_float(path, key = nil)
			return get_value(path, key).to_f rescue nil
		end

		def get_datetime(path, key)
			return DateTime.strptime(get_string(path, key), '%F %T')
		end
	end
end