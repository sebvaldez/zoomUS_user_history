# Config ENV vars for zoom
ENV["ZOOM_API_KEY"] = Rails.application.secrets.zoom_api_key
ENV["ZOOM_API_SECRET"] = Rails.application.secrets.zoom_api_secret