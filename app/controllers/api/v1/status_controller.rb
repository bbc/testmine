class API::V1::StatusController < API::V1Controller
  def show
    render status: 200, json: { status: 'ok' }
  end
end
