# frozen_string_literal: true

#  Fish_catch Likes
class Like < ApplicationRecord
  include ActionView::RecordIdentifier # Needed to use dom_id helper

  belongs_to :user
  belongs_to :fish_catch, counter_cache: true

  after_create_commit do
    broadcast_update_later_to(
      'catches_activity',
      target: "#{dom_id(self.fish_catch)}_likes_count",
      html: self.fish_catch.likes_count
    )
  end

  # NOTE: line 'locals: { like: nil }' is necessary to avoid deserialization error.
  #       By default, the broadcast contains a "locals: { like: self }"
  #       BUT: because we are broadcasting asynchronously after a destroy, it is
  #       possible that the like has been deleted, so set it to nil here.
  after_destroy_commit do
    broadcast_update_later_to(
      'catches_activity',
      target: "#{dom_id(self.fish_catch)}_likes_count",
      html: self.fish_catch.likes_count,
      locals: { like: nil }
    )
  end
end
