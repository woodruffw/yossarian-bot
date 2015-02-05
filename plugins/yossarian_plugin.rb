#  yossarian_plugin.rb
#  Author: William Woodruff
#  ------------------------
#  The superclass that all yossarian-bot plugins extend.
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

class YossarianPlugin
	# default usage stub
	def usage
		''
	end

	#default match stub
	def match?(cmd)
		false
	end
end
