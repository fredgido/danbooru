# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    @count = Post.count
    render("index", layout: "blank")
  end
end
