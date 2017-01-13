# top-level class documentation comment
module AdminHelper
  def get_panel_title
    title = 'Адмін панель'
    title += " | #{@title}" unless @title.nil?
  end

  def get_ukr_order_state(state)
    case state
    when 'process'
      'в очікуванні'
    when 'sandbox'
      'оплачено'
    when 'failure'
      'помилка'
    end
  end
end
