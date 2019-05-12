# frozen_string_literal: true

class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response

  def render_unprocessable_entity_response(exception)
    render json: exception.record.errors, status: :unprocessable_entity
 end

  def render_not_found_response(exception)
    render json: { error: exception.message }, status: :not_found
 end

  def serialized_collection(collection, serializer)
    ActiveModel::Serializer::CollectionSerializer
      .new(collection, each_serializer: serializer)
  end
end
