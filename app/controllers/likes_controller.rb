# frozen_string_literal: true

# Likes Controller
class LikesController < ApplicationController
  before_action :require_signin
  before_action :find_fish_catch

  def create
    return if existing_like

    #  This is a new like, so create the like and assign it to the fish_catch
    like = @fish_catch.likes.create!(user: current_user)
    @fish_catch.my_like = like

    # NOTE:  The definition of the turbo_frame is in partial 'activity/catch_likes',
    #        so, by rendering that partial here, this create action is responding to
    #        the like with a matching turbo_frame.  So, we get the partial-specific
    #        response we want.
    render partial: 'activity/catch_likes', locals: { fish_catch: @fish_catch }
  end

  def destroy
    return unless (like = existing_like)

    like.destroy!

    # NOTE:  The definition of the turbo_frame is in partial 'activity/catch_likes',
    #        so, by rendering that partial here, this create action is responding to
    #        the like with a matching turbo_frame.  So, we get the partial-specific
    #        response we want.
    render partial: 'activity/catch_likes', locals: { fish_catch: @fish_catch }
  end

  private

  def find_fish_catch
    @fish_catch = FishCatch.find(params[:fish_catch_id])
  end

  def existing_like
    @fish_catch.likes.where(user: current_user).first
  end
end
