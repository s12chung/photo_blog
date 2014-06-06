class MarkdownsController < ApplicationController
  before_filter :authorize, except: %i[show]

  def edit
    @markdown = Markdown.find(params[:id])
  end

  def update
    edit
    @markdown.update_attributes update_params
    redirect_to edit_markdown_path(@markdown)
  end

  protected
  def update_params
    params.require(:markdown).permit(:markdown)
  end
end