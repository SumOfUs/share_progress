module ShareProgress
  class ShareProgressError < StandardError; end
  class RecordNotFound < ShareProgressError; end
  class ApiError < ShareProgressError; end
  class AnalyticsNotFound < ShareProgressError; end
  class CouldNotParseVariant < ShareProgressError; end
end
