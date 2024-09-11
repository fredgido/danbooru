# frozen_string_literal: true

module HomeHelper
  def catgirl_counter_for(number)
    number.digits.reverse.map do |i|
      image_pack_tag("static/counter-#{i}.gif")
    end.join.html_safe
  end
end
