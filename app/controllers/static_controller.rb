class StaticController < ApplicationController

  # skip_before_action :doorkeeper_authorize, only: [:fcm_token]

  def fcm_token
    render template: "static/fcm_token"
  end
end
