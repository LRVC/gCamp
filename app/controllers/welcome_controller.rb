class WelcomeController < ApplicationController
  def index
    @quotesArray = [
        {author: "-Cayla Hayes", quote: "gCamp has changed my life! It's the best tool I've ever used."},
        {author: "-Leta Jaskolski", quote: "Before gCamp I was a disorderly slob. Now I'm more organized than I've ever been" },
        {author: "-Laverne Upton", quote: "Don't hesitate - Sign up right now!"}
      ]
  end
end


@exampleArrray = [{key: "pianos"}]
