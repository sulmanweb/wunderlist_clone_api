class V1::ListsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_list, only: [:show, :update, :destroy]

  # GET /v1/lists
  def index
    @lists = current_user.lists.all.order(id: :desc)
    return render_success_list_index
  end

  # GET /v1/lists/1
  def show
    return render_success_list_save
  end

  # POST /v1/lists
  def create
    @list = current_user.lists.build(list_params)

    if @list.save
      return render_success_list_created
    else
      return render_error_save :unprocessable_entity, @list
    end
  end

  # PATCH/PUT /v1/lists/1
  def update
    if @list.update(list_params)
      return render_success_list_save
    else
      return render_error_save :unprocessable_entity, @list
    end
  end

  # DELETE /v1/lists/1
  def destroy
    @list.destroy
    return render_success_list_destroyed
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_list
    @list = current_user.lists.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def list_params
    params.permit(:name)
  end

  protected

  def render_success_list_created
    render status: :created, template: 'lists/show.json.jbuilder'
  end

  def render_success_list_save
    render status: :ok, template: 'lists/show.json.jbuilder'
  end

  def render_success_list_index
    render status: :ok, template: 'lists/index.json.jbuilder'
  end

  def render_success_list_destroyed
    render status: :no_content, json: {}
  end
end
