module Paginatable
  extend ActiveSupport::Concern

  # This method will handle pagination for controller actions
  #
  # @param [Mongoid::Criteria] criteria The collection to paginate
  # @param [Hash] opts Pagination options like limit, page, and offset
  # @return [Mongoid::Criteria] Paginated criteria
  def paginate(criteria, opts = {})
    limit = (opts[:limit] || params[:per_page].presence || 20).to_i
    page = (opts[:page] || params[:page].presence || 1).to_i

    total_count = criteria.count
    total_pages = (total_count.to_f / limit).ceil

    offset = (page > 1) ? (page - 1) * limit : 0

    base_url = request.base_url + request.path
    query_params = request.query_parameters.except(:page)

    links = {
      first: page > 1 ? "#{base_url}?#{query_params.to_query}&page=1" : nil,
      prev: page > 1 ? "#{base_url}?#{query_params.to_query}&page=#{page - 1}" : nil,
      next: page < total_pages ? "#{base_url}?#{query_params.to_query}&page=#{page + 1}" : nil,
      last: page < total_pages ? "#{base_url}?#{query_params.to_query}&page=#{total_pages}" : nil
    }

    [ links, criteria.limit(limit).skip(offset) ]
  end
end
