class BookDecorator < Draper::Decorator
  delegate_all

  def authors_short
    # model.authors
         # .sort_by(&:last_name)
         # .map { |author| "#{author.first_name[0]}. #{author.last_name}" }
         # .join(', ')
    authors_string do |authors|
      authors.map { |author| "#{author.first_name[0]}. #{author.last_name}" }
    end
  end

  def authors_full
    # model.authors
         # .sort_by(&:last_name)
         # .map { |author| "#{author.first_name} #{author.last_name}" }
         # .join(', ')
    authors_string do |authors|
      authors.map { |author| "#{author.first_name} #{author.last_name}" }
    end
  end

  def materials_string
    model.materials.map(&:name).sort.join(', ').capitalize
  end

  def dimensions
    "H: #{model.height}\" x W: #{model.width}\" x D: #{model.thickness}\""
  end

  private

  def authors_string
    yield(model.authors.sort_by(&:last_name)).join(', ')
  end
end
