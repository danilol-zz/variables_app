# encoding : utf-8
class ScriptsController < ApplicationController
  before_filter :ensure_authentication, :only => [:index]

  def index
  end

end
