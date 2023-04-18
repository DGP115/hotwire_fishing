# frozen_string_literal: true

# Helpers
module FishCatchesHelper
  def total_weight(fish_catches)
    fish_catches.map(&:weight).reduce(0, &:+)
  end

  def sort_link_to(name, column)
    name = raw("#{name} #{direction_indicator(column)}")

    params = request.params
                    .merge(sort: column, direction: next_direction(column))

    # NOTE:  Do not specify the data-controller here because that caused problems and
    #        is redundent, since this link is within <div data-controller="sort-link">
    #        in the DOM [via fish_catches/index.html.erb]
    #
    #        When clicked on, the column headers call method 'updateForm' in the
    #        sort-link-controller to write the sort column and direction data to stimulus
    #        targets in the form [to "save" them so that sort criteria is preserved
    #        when navigating away from the page]
    link_to name, params, data: { turbo_action: 'advance',
                                  action: 'turbo:click->sort-link#updateForm' }
  end

  def next_direction(column)
    if currently_sorted?(column)
      params[:direction] == 'asc' ? 'desc' : 'asc'
    else
      'asc'
    end
  end

  def direction_indicator(column)
    return unless currently_sorted?(column)

    tag.span(class: "sort sort-#{next_direction(column)}")
  end

  def currently_sorted?(column)
    params[:sort] == column.to_s
  end
end
