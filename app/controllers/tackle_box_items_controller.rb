# frozen_string_literal: true

# Tackle_box Iytems Controller
class TackleBoxItemsController < ApplicationController
  before_action :require_signin

  def index
    item = current_user.tackle_box_item_for_most_recent_catch
    if !item.nil?
      redirect_to action: :show, id: item
    else
      render :empty
    end
  end

  def show
    @item = current_user.tackle_box_items.find(params[:id])

    @items = current_user.tackle_box_items
                         .order(created_at: :asc)
                         .includes(:bait)

    @new_catch = current_user.fish_catches.new(bait: @item.bait)

    @fish_catches = current_user.fish_catches
                                .where(bait: @item.bait)
                                .order(created_at: :desc)
  end

  def create
    @bait = Bait.find(params[:bait_id])
    @item = current_user.tackle_box_items.create!(bait: @bait)

    @bait.my_tackle_box_item = @item
  end

  def destroy
    @item = current_user.tackle_box_items.find(params[:id])
    @item.destroy

    # To render the bait partial we need to set @bait
    @bait = @item.bait
    render 'tackle_box_items/create'
  end
end
