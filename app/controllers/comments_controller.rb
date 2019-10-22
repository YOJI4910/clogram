class CommentsController < ApplicationController
  def create
    # Commentモデルにuser_id(current_user), body, igpost_idを渡してコミット
    comment = current_user.comments.build(comment_params)
    igpost = comment.igpost
    if comment.save
      # comment通知
      igpost.create_notification_comment!(current_user, comment.id)
      # jsonを返す(Ajax)
      render :json => [comment.body, current_user.user_name]
    else
      render 'igposts/show'
    end
  end

  def destroy
  end

  private

  def comment_params
    params.require(:comment).permit(:body).merge(params.permit(:igpost_id))
  end
end
