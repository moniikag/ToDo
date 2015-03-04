class TagController < ApplicationController

def index
 # @tags = Tag.all
end

def create
	@tag = Tag.find(params[:tag_id])
	# @tags = Tag.find(:all)
end