module ShareProgress
  class ShareProgressError < StandardError; end
  class RecordNotFound < ShareProgressError; end
  class AnalyticsNotFound < ShareProgressError; end
end
