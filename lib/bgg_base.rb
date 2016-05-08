module BoardGameGem
	class BGGBase
		protected

		def get_value(xml, path, key = nil)
			item = xml.at_css(path)
			if item.nil?
				return nil
			end
			if key.nil?
				return item.content
			else
				return item[key]
			end
		end

		def get_values(xml, path, key = nil)
			results = []
			xml.css(path).each do |item|
				if key.nil?
					results.push(item.content)
				else
					results.push(item[key])
				end
			end
			return results
		end

		def get_boolean(xml, path, key = nil)
			return get_integer(xml, path, key) == 1 rescue nil
		end

		def get_integer(xml, path, key = nil)
			return get_value(xml, path, key).to_i rescue nil
		end

		def get_integers(xml, path, key = nil)
			return get_values(xml, path, key).map {|x| x.to_i } rescue nil
		end

		def get_string(xml, path, key = nil)
			return get_value(xml, path, key).to_s rescue nil
		end

		def get_strings(xml, path, key = nil)
			return get_values(xml, path, key).map {|x| x.to_s } rescue nil
		end

		def get_float(xml, path, key = nil)
			return get_value(xml, path, key).to_f rescue nil
		end

		def get_datetime(xml, path, key)
			return DateTime.strptime(get_string(xml, path, key), '%F %T')
		end
	end
end