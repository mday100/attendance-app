class VisitorsController < ApplicationController

	def new
		@visitor = Visitor.new
	end

	def create
		@visitor = Visitor.new(secure_params) 
		if @visitor.valid?
			@visitor.subscribe
			flash[:notice] = "#{@visitor.fname}, you are signed in!" 
			redirect_to root_path
		else
			render :new
		end 
	end

	private

	def secure_params 
		params.require(:visitor).permit(:email, :fname, :lname)
	end

end