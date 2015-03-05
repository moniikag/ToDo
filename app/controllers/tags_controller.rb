class TagsController < ApplicationController

	def new
		@tag = Tag.new
	end

	def index
	  @tags = Tag.all
	end

	def tag_params
		params[:tag].permit(:name)
	end

	def create
		@tag = Tag.new(tag_params)
	end

	def update
		@tag = Tag.find(params[:tag_id])
		# @tags = Tag.find(:all)
	end

 t = Tag.create(name: "sth")
 t.save

end