class EmailsController < ApplicationController
  def create
    require 'tmail'
    email = TMail::Mail.parse(params[:email])
  end
end
