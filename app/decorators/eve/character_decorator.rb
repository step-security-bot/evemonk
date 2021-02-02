# frozen_string_literal: true

module Eve
  class CharacterDecorator
    def birthday
      object.birthday&.iso8601
    end

    def security_status
      object.security_status.round(1).to_s
    end
  end
end
