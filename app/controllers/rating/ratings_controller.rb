class Rating::RatingsController < Rating::BaseController
  before_filter :set_redirect_path, only: [:create, :update]

  # In order to get the rating data persisted, FIRST create the rating record,
  # then update it to actually set the values.
  def create
    rating = find_or_create_rating
    rating.update new_rating_params
    redirect_to @redirect_path
  end

  def update
    rating = Rating.by(current_user).find(params[:id])
    rating.update(rating_attr_params)
    redirect_to @redirect_path
  end

  private
    def set_redirect_path
      @redirect_path = rating_applications_path
    end

    def new_rating_params
      params.require(:rating).permit(:rateable_id, :rateable_type, :pick, Rating::FIELDS.keys)
    end

    def rating_attr_params
      params.require(:rating).permit(:pick, Rating::FIELDS.keys)
    end

    def find_or_create_rating
      rateable_args = new_rating_params.values_at(:rateable_type, :rateable_id)
      Rating.by(current_user).for(*rateable_args).first_or_create
    end
end
