class HomeController < ApplicationController
  before_filter :authenticate_user!, only: 'protected_page'
end
