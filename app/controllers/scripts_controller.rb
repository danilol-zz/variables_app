# encoding : utf-8
class ScriptsController < ApplicationController
  before_filter :ensure_authentication, :only => [:index]

  def index
    @scripts_list = Support::HASH_SCRIPTS.keys
    @generated_script = ""
    sprint = params["sprint_number"]
    if sprint
      script_name = params["script_name"]
      sprint = sprint.to_i
      begin
        @generated_script = Generator.export_script_by_sprint(sprint, script_name)
        @script_name = @generated_script.split("\n")[0].split(": ")[1]
      rescue
        params[:errors] = "Para os valores informados, não há scripts a serem gerados."
      end
    end
  end

end
