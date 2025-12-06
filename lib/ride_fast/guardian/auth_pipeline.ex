defmodule RideFast.Guardian.AuthPipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :ride_fast,
    module: RideFast.Guardian,
    error_handler: RideFastWeb.AuthErrorHandler

  plug Guardian.Plug.VerifyHeader, scheme: "Bearer"

  plug Guardian.Plug.EnsureAuthenticated

  plug Guardian.Plug.LoadResource
end
