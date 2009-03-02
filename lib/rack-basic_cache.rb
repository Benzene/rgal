module Rack
	class BasicCache
		def initialize(app)
			@app = app
		end

		def call(env)
			res = @app.call(env)

			if can_cache(env, res)
				res[1]['Cache-Control'] = 'max-age=3600, must-revalidate'
			end

			res
		end

		protected

		def can_cache(env, res)
			(env['REQUEST_METHOD'] == 'GET' || env['REQUEST_METHOD'] == 'HEAD') or return false
			(env['QUERY_STRING'].length == 0) or return false
			(res[0] == 200) or return false
		end
	end
end
