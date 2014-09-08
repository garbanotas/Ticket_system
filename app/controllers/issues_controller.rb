class IssuesController < ApplicationController
  before_action :set_issue, only: [:show, :edit, :update]
  before_action :authenticate_user!, only: [:index, :edit]
  # GET /issues
  # GET /issues.json
  def index
    @issues = case params[:scope]
    when "Unassigned"
      Issue.unassigned
    when "Hold"
      Issue.hold
    when "Completed"
      Issue.completed  
    else
      Issue.all    
    end  
  end

  def update
    binding.pry
    body = if params[:issue][:replies_attributes] && current_user
             params[:issue][:replies_attributes][:body]
           elsif params[:issue][:reply]
             params[:issue][:reply][:body]
    end          
    @issue.replies.build(body: body, author_id: current_user.try(:id)) if body.present?
    status = ("#{params[:status]}" + "!").to_sym
    user_id = params[:user][:user] if params[:user]
    @issue.owner = User.find_by_id(user_id)
    @issue.send(status)
    if @issue.update_attributes(issue_params)
      redirect_to @issue, notice: 'Issue was successfully updated.'
    else
      render action: 'edit'
    end
  end  

  # GET /issues/1
  # GET /issues/1.json
  def show
  end

  def edit
  end

  # GET /issues/new
  def new
    @issue = Issue.new
  end

  # POST /issues
  # POST /issues.json
  def create
    @issue = Issue.new(issue_params)

    respond_to do |format|
      if @issue.save
        TicketMailer.delay.message_mail(@issue)
        format.html { redirect_to @issue, notice: 'Issue was successfully created.' }
        format.json { render action: 'show', status: :created, location: @issue }
      else
        format.html { render action: 'new' }
        format.json { render json: @issue.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_issue
      @issue = Issue.find(params[:id])
      redirect_to( root_path, notice: "Issue not found" ) and return if @issue.blank?
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def issue_params
      params.require(:issue).permit(:name, :email, :header, :state, :owner_id, replies_attributes: [:body])
    end
end
