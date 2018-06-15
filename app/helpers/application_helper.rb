module ApplicationHelper
  # Present pretty version of date and time.
  #
  # @param datetime [Time] Date and time to present
  # @return [String] Date and time pretty printed
  def present_datetime(datetime)
    datetime.nil? ? '' : datetime.strftime('%m/%d/%Y %H:%M')
  end
end
