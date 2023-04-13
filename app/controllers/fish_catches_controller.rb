# frozen_string_literal: true

#  Fish Catches Controller
class FishCatchesController < ApplicationController
  before_action :require_signin
  before_action :set_fish_catch, only: %i[show edit update destroy]

  def index
    @pagy, @fish_catches =
      pagy(current_user.filter_catches(params),
           items: params[:per_page] ||= 5)

    @bait_names = Bait.pluck(:name)
    @species = FishCatch::SPECIES
  end

  def show; end

  def edit; end

  def update
    if @fish_catch.update(fish_catch_params)
      @fish_catches = fish_catches_for_bait(@fish_catch.bait)
      flash.now[:notice] = 'The catch was successfully updated.'
      # redirect_to tackle_box_item_for_catch(@fish_catch)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def create
    @fish_catch = current_user.fish_catches.new(fish_catch_params)


    if @fish_catch.save
      # Normally, a flash message is displayed on the next rendering of whatever
      # layout the flash partial is in.  When using Turbo, the full page is not being
      # refreshed, so we want to render the flash message on this cycle.
      # So, we use flash.now.
      flash.now[:notice] = 'The catch was successfully created.'

      # redirect_to tackle_box_item_for_catch(@fish_catch)
      # update fish_catches, since we are going to be re-rendering this collection
      @fish_catches = fish_catches_for_bait(@fish_catch.bait)
      @new_catch = current_user.fish_catches
                               .new(bait: @fish_catch.bait)
    else
      # A "common" solution here is the following, with renders the new form as a separate page
      # render :new, status: :unprocessable_entity
      # But, we want to render a form on the current page.
      # Note:  that form is wrapped in a turbo_frame_tag
      render 'fish_catches/new',
             locals: { fish_catch: @fish_catch },
             status: :unprocessable_entity
    end
  end

  def destroy
    @fish_catch.destroy

    # update fish_catches, since we are going to be re-rendering this collection
    @fish_catches = fish_catches_for_bait(@fish_catch.bait)

    # Normally, a flash message is displayed on the next rendering of whatever
    # layout the flash partial is in.  When using Turbo, the full page is not being
    # refreshed, so we want to render the flash message on this cycle.
    # So, we use flash.now.
    flash.now[:notice] = 'The catch was successfully deleted.'
  end

  private

  def set_fish_catch
    @fish_catch = current_user.fish_catches.find(params[:id])
  end

  def fish_catch_params
    params.require(:fish_catch).permit(:species, :weight, :length, :bait_id)
  end

  def tackle_box_item_for_catch(fish_catch)
    current_user.tackle_box_items.find_sole_by(bait: fish_catch.bait)
  end

  def fish_catches_for_bait(bait)
    current_user.fish_catches.where(bait: bait).select(:weight)
  end
end
