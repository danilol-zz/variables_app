# encoding : utf-8
class ScriptsController < ApplicationController
  before_filter :ensure_authentication, :only => [:index]

  def index

  end

  def generate_script

    @generated_script = ""

    if params["sprint_number"] != "" && params["script_name"] != ""
      sprint = params["sprint_number"].to_i
      script_name = params["script_name"]
      @generated_script = ExportScript.export_script_by_sprint(sprint, script_name)
    end

    render "index",  generated_script: @generated_script
  end

end
