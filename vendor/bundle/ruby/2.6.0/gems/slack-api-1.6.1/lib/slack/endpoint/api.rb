# This file was auto-generated by lib/generators/tasks/generate.rb

module Slack
  module Endpoint
    module Api
      #
      # Checks API calling code.
      #
      # @option options [Object] :error
      #   Error response to return
      # @option options [Object] :foo
      #   example property to return
      # @see https://api.slack.com/methods/api.test
      # @see https://github.com/aki017/slack-api-docs/blob/master/methods/api.test.md
      # @see https://github.com/aki017/slack-api-docs/blob/master/methods/api.test.json
      def api_test(options={})
        post("api.test", options)
      end

    end
  end
end
