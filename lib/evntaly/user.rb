module Evntaly
  class User
    attr_accessor :id, :email, :full_name, :organization, :data

    def initialize(id:, email:, full_name:, organization:, data:)
      @id = id
      @email = email
      @full_name = full_name
      @organization = organization
      @data = data
    end

    def to_json(*_args)
      {
        id: @id,
        email: @email,
        full_name: @full_name,
        organization: @organization,
        data: @data
      }.to_json
    end
  end
end
