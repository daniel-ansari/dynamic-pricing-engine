module API
  class HealthController < API::APIController
    def status
      render json: { online: true }
    end
  end
end
