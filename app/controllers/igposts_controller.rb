class IgpostsController < ApplicationController
  include Pagy::Backend
  def index
    @pagy, @igposts = pagy(Igpost.all.order(id: "DESC"))
  end

  def show
    @igpost = Igpost.find(params[:id])
    @comments = @igpost.comments.order(id: "DESC")
    @comment = Comment.new
  end

  def new
    @igpost = Igpost.new
  end

  def create
    @igpost = current_user.igposts.new(record_params)

    if @igpost.save!
      redirect_to @igpost, notice: '写真を投稿しました'
    end
  end

  def edit
  end

  def destroy
  end

  private

  def record_params
    params.require(:igpost).permit(:image)
  end
end
