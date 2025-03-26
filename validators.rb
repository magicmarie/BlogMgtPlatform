require 'dry-validation'

# : operator to call (nested) methods defined within a class or module.
PostSchema = Dry::Schema.Params do
  required(:title).filled(:string)
  required(:content).filled(:string)
  required(:author).filled(:string)
  required(:tags).array(:string)
  required(:date).filled(:string)
  required(:bookmarked).filled(:bool)
end

CommentSchema = Dry::Schema.Params do
  required(:postId).filled(:string)
  required(:author).filled(:string)
  required(:content).filled(:string)
  required(:date).filled(:string)
end
