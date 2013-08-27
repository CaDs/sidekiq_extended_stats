module Sidekiq
  class ExtendedStats
    def scheduled
      Sidekiq::ScheduledSet.new.select.collect{|job| {klass: job.klass.to_s, args: YAML.load(job.args.first).to_s}}
    end

    def queued(queue)
      Sidekiq::Queue.new(queue.to_s).select.collect{|job| {klass: job.klass.to_s, args: YAML.load(job.args.first).to_s}}
    end

    def current
      payloads = Sidekiq::Workers.new.collect{|name, job, date| job}
      args = payloads.collect{|job| YAML.load(job["payload"]["args"].first).first(2)}
      args.collect{|klass, arg| {klass: klass.to_s, args: arg.to_s}}
    end

  end
end