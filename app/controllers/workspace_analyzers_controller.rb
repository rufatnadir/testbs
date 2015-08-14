#require_relative '../../../test_automation/AutomationFrameWork/lib/analyzer'

class WorkspaceAnalyzersController < ApplicationController
  before_action :set_workspace_analyzer, only: [:show, :edit]

  # GET /workspace_analyzers
  # GET /workspace_analyzers.json
  def index
    #flash[:notice] = 'Inside index'
    @workspace_analyzer = WorkspaceAnalyzer.new('','')
  end

  # GET /workspace_analyzers/1
  # GET /workspace_analyzers/1.json
  # def show
  # end

  # GET /workspace_analyzers/new
  #def new
    #flash[:notice] = 'Inside new'
    #@workspace_analyzer = WorkspaceAnalyzer.new('ab','ad')
  #end

  # GET /workspace_analyzers/1/edit
  # def edit
  # end

  # POST /workspace_analyzers
  # POST /workspace_analyzers.json
  #def create
  #end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_workspace_analyzer
      #flash[:notice] = 'Inside set_workspace_analyzer'
      @workspace_analyzer = WorkspaceAnalyzer.new(params[:workspace_id], params[:environment], params[:summaryonly])
      @workspace_analyzer.analyze
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def workspace_analyzer_params
      params.require(:workspace_analyzer).permit(:workspace_id, :environment, :results)
    end
end
