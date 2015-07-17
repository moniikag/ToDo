module TodoItemsHelper

  def deadline_from_form
    date = Date.parse(params[:todo_item][:date])
    day = date.day
    month = date.month
    year = date.year
    hour = params[:todo_item][:hour]
    minutes = params[:todo_item][:minutes]
    deadline = Time.new(year, month, day, hour, minutes)
  rescue
    return nil
  end

end

