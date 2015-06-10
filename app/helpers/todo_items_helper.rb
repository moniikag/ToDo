module TodoItemsHelper

  def deadline_from_form
    date = params[:todo_item][:date].split('/')
    day = date[0]
    month = date[1]
    year = date[2]
    hour = params[:todo_item][:hour]
    minutes = params[:todo_item][:minutes]
    deadline = Time.new(year, month, day, hour, minutes)+ 2.hours
  rescue
    return nil
  end

end
