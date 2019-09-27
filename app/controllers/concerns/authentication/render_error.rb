module Authentication
  module RenderError
    extend ActiveSupport::Concern

    def render_unauthenticated(return_hash)
      render json: return_hash, status: :unauthorized
    end

    def render_bad_request(return_hash)
      render json: return_hash, status: :bad_request
    end
  end
end
