module ModulectAdmin
	class UsersController < ModulectAdmin::BaseController


		def index
			@users = User.all
		end
 


	end
end