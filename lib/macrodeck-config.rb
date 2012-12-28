# Loads the config file for the current environment.

require "yaml"
require "sinatra"

module MacroDeck
	class Config
		attr_reader :admin_username
		attr_reader :admin_password
		attr_reader :db_url
		attr_reader :environment
		attr_reader :layout
		attr_reader :view_dir
		attr_reader :path_prefix
		attr_reader :turk_path_prefix
		attr_reader :turk_sandbox
		attr_reader :turk_reward
		attr_reader :turk_hit_type_id
		attr_reader :aws_access_key
		attr_reader :aws_secret_access_key
		attr_reader :base_url

		def initialize(yaml_path)
			File.open(yaml_path) do |yml|
				@config = YAML::load(yml)
			end

			@environment = Sinatra::Application.environment.to_sym
			@env_config = @config[@environment.to_s]

			if @env_config
				if @env_config["admin_username"]
					@admin_username = @env_config["admin_username"]
				else
					@admin_username = "admin"
				end

				if @env_config["admin_password"]
					@admin_password = @env_config["admin_password"]
				else
					@admin_password = "admin"
				end

				if @env_config["db_url"]
					@db_url = @env_config["db_url"]
				else
					@db_url = "macrodeck-#{@environment.to_s}"
				end

				if @env_config["layout"]
					@layout = @env_config["layout"]
				else
					@layout = "layout"
				end

				if @env_config["view_dir"]
					@view_dir = @env_config["view_dir"]
				else
					@view_dir = "views"
				end

				if @env_config["path_prefix"]
					@path_prefix = @env_config["path_prefix"]
				else
					@path_prefix = "/"
				end

				if @env_config["turk_path_prefix"]
					@turk_path_prefix = @env_config["turk_path_prefix"]
				else
					@turk_path_prefix = "/turk/"
				end

				if @env_config["turk_sandbox"]
					@turk_sandbox = @env_config["turk_sandbox"]
				else
					@turk_sandbox = true
				end

				if @env_config["turk_reward"]
					@turk_reward = @env_config["turk_reward"]
				else
					@turk_reward = 0.0
				end

				if @env_config["turk_hit_type_id"]
					@turk_hit_type_id = @env_config["turk_hit_type_id"]
				else
					@turk_hit_type_id = nil
				end

				if @env_config["aws_access_key"]
					@aws_access_key = @env_config["aws_access_key"]
				else
					@aws_access_key = ""
				end

				if @env_config["aws_secret_access_key"]
					@aws_secret_access_key = @env_config["aws_secret_access_key"]
				else
					@aws_secret_access_key = ""
				end

				if @env_config["base_url"]
					@base_url = @env_config["base_url"].gsub(/\/$/, "")
				else
					@base_url = "http://localhost:3000"
				end
			end

			# Configure RTurk if we have enough data
			if defined?(RTurk)
				if @aws_access_key != "" && @aws_secret_access_key != ""
					if @turk_sandbox
						RTurk.setup(@aws_access_key, @aws_secret_access_key, :sandbox => true)
					else
						RTurk.setup(@aws_access_key, @aws_secret_access_key, :sandbox => false)
					end
				end
			end
		end

		def hit_review_policy_defaults
			{
				"QuestionIds" => "answer",
				"QuestionAgreementThreshold" => 50, # More than half have to have the same answer to agree
				"DisregardAssignmentIfRejected" => false,
				"ExtendIfHITAgreementScoreIsLessThan" => 100, # The question MUST have an agreed upon answer or we extend
				"ExtendMaximumAssignments" => 10, # At most 10 people have to come to an agreement. Should be more like 3.
				"ExtendMinimumTimeInSeconds" => 86400,
				"ApproveIfWorkerAgreementScoreIsNotLessThan" => 99, # if they get the question right, approve the assignment.
				"RejectIfWorkerAgreementScoreIsLessThan" => 100, # if they didn't get it right, reject the answer.
				"RejectReason" => "Your answer did not agree with the answer of other workers."
			}.freeze
		end
	end
end

# vim:set ft=ruby
