# frozen_string_literal: true

class CharacterOrdersJob < ApplicationJob
  queue_as :important

  retry_on EveOnline::Exceptions::Timeout,
    EveOnline::Exceptions::ServiceUnavailable,
    EveOnline::Exceptions::BadGateway,
    EveOnline::Exceptions::InternalServerError,
    Faraday::TimeoutError,
    Faraday::ConnectionFailed

  discard_on CharacterInvalidToken

  def perform(character_id)
    CharacterOrdersImporter.new(character_id).import
  end
end
