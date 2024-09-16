class IndexTicketsToElasticsearchJob
  include Sidekiq::Job

  def perform(*args)
    Rails.logger.info("Running inside IndexTicketsToElasticsearchJob")
  end
end
