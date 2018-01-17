class V1::TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_list
  before_action :set_task, only: [:show, :update, :destroy]

  # GET /tasks
  # GET /tasks.json
  def index
    @tasks = @list.tasks.order(status: :asc)
    return render_success_task_index
  end

  # GET /tasks/1
  # GET /tasks/1.json
  def show
    return render_success_task_save
  end

  # POST /tasks
  # POST /tasks.json
  def create
    @task = @list.tasks.build(task_params)

    if @task.save
      return render_success_task_created
    else
      return render_error_save @task
    end
  end

  # PATCH/PUT /tasks/1
  # PATCH/PUT /tasks/1.json
  def update
    if @task.update(task_params)
      return render_success_task_save
    else
      return render_error_save @task
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    @task.destroy
    return render_success_task_destroyed
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_list
    @list = current_user.lists.find(params[:list_id])
  end

  def set_task
    @task = @list.tasks.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def task_params
    params.permit(:name, :status)
  end

  protected

  def render_success_task_index
    render status: :ok, template: 'tasks/index.json.jbuilder'
  end

  def render_success_task_save
    render status: :ok, template: 'tasks/show.json.jbuilder'
  end

  def render_success_task_created
    render status: :created, template: 'tasks/show.json.jbuilder'
  end

  def render_success_task_destroyed
    render status: :no_content, json: {}
  end
end
