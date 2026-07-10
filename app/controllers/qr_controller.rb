require "rqrcode"

class QrController < ApplicationController
  allow_unauthenticated_access

  # Dev-only helper for the workshop: renders a QR code of this app's public
  # URL so attendees can open it on their phone without copy-pasting.
  def show
    return head :not_found unless Rails.env.development?

    @in_codespace = ENV["CODESPACE_NAME"].present?
    @url = public_url
    @svg = RQRCode::QRCode.new(@url)
      .as_svg(standalone: true, viewbox: true, use_path: true)
      .sub(/\A<\?xml.*?\?>/, "")
  end

  private

  # Inside a Codespace we can build the canonical *.app.github.dev URL from the
  # environment. Locally we fall back to however this page was reached, so
  # loading it via your machine's LAN IP produces a QR a phone can scan.
  def public_url
    name = ENV["CODESPACE_NAME"]
    domain = ENV["GITHUB_CODESPACES_PORT_FORWARDING_DOMAIN"]

    if name && domain
      "https://#{name}-#{ENV.fetch("PORT", "3000")}.#{domain}"
    else
      request.base_url
    end
  end
end
