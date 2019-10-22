module NotificationsHelper
  include Pagy::Frontend

  def unchecked_notifications
    @notifications = current_user.passive_notifications.where(checked: false) if current_user.present?
  end
end
