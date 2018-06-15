module ApplicationHelper
  def present_datetime(datetime)
    datetime.strftime('%m/%d/%Y %H:%M')
  end
end
