module Evntaly
  class Event
    attr_accessor :title, :description, :message, :data, :tags, :notify, :icon,
                  :apply_rule_only, :user, :type, :session_id, :feature, :topic

    def initialize(title:, description:, message:, data:, tags:, notify:, icon:, apply_rule_only:, user:, type:, session_id:, feature:, topic:)
      @title = title
      @description = description
      @message = message
      @data = data
      @tags = tags
      @notify = notify
      @icon = icon
      @apply_rule_only = apply_rule_only
      @user = user
      @type = type
      @session_id = session_id
      @feature = feature
      @topic = topic
    end

    def to_json(*_args)
      {
        title: @title,
        description: @description,
        message: @message,
        data: @data,
        tags: @tags,
        notify: @notify,
        icon: @icon,
        apply_rule_only: @apply_rule_only,
        user: @user,
        type: @type,
        session_id: @session_id,
        feature: @feature,
        topic: @topic
      }.to_json
    end
  end
end
