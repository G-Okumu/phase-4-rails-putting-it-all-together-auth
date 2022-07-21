class RecipesController < ApplicationController

    def index
        render json: Recipe.all, status: :ok
    end

    def create
        render json: @logged_user.recipes.create!(recipe_params), status: :created
    end

    private 

    def recipe_params
        params.permit(:title, :instructions, :minutes_to_complete)
    end
end
