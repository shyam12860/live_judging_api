class EventTeamsController < ApplicationController
  api :GET, "/event/:event_id/teams", "Get a list of event teams"
    description "Get a list of all teams for an event."
    error code: :unauthorized, desc: " - Bad Token"
    header "Authorization", "Token token=[access_token]", required: true
  def index
    @teams = EventTeam.where( event_id: params[:event_id] )
    authorize @teams

    render json: @teams, status: :ok
  end

  api :POST, "/events/:event_id/teams", "Create a new event team. Must be an organizer of the event"
    description "Create a new team for an event."
    error code: :unprocessable_entity, desc: " - Bad parameters for User"
    error code: :unauthorized, desc: " - Bad Token"
    param :name, String, desc: "Team name", required: true
    header "Authorization", "Token token=[access_token]", required: true
  def create
    params[:logo] = parse_image_data( params[:logo_base64] ) if params[:logo_base64]

    Rails.logger.debug( "\n\n\n" )
    Rails.logger.debug( params[:logo].path() )
    Rails.logger.debug( "\n\n\n" )

    @team = EventTeam.new( create_params )
    authorize @team

    if @team.save
      render json: @team, status: :created
    else
      render json: @team.errors, status: :unprocessable_entity
    end
  ensure
    clean_tempfile
  end

  api :PUT, "/teams/:id", "Update an event team. Must be an organizer of the event"
    description "Update an event team."
    error code: :unprocessable_entity, desc: " - Bad parameters for User"
    error code: :unauthorized, desc: " - Bad Token"
    param :name, String, desc: "Team name", required: true
    header "Authorization", "Token token=[access_token]", required: true
  def update
    @team = EventTeam.find( params[:id] )
    authorize @team

    params[:logo] = parse_image_data( params[:logo_base64] ) if params[:logo_base64]

    if @team.update_attributes( update_params )
      render json: @team, status: :ok
    else
      render json: @team.errors, status: :unprocessable_entity
    end
  ensure
    clean_tempfile
  end

  api :DELETE, "/teams/:id", "Delete an event team. Must be an organizer of the event."
    description "Delete an event team."
    error code: :not_found, desc: " - Requested event team did not exist"
    error code: :unauthorized, desc: " - Bad Token"
    header "Authorization", "Token token=[access_token]", required: true
  def destroy
    @team = EventTeam.find( params[:id] )
    authorize @team
    @team.destroy

    head :ok
  end

  private
    def create_params
      params.permit( :event_id, :name, :logo )
    end
    
    def update_params
      params.permit( :name, :logo )
    end

    def parse_image_data( base64_image )
      filename = "upload-image"
      in_content_type, encoding, string = base64_image.split( /[:;,]/ )[1..3]
   
      @tempfile = Tempfile.new( filename )
      @tempfile.binmode
      @tempfile.write Base64.decode64( string )
      @tempfile.rewind
   
      # for security we want the actual content type, not just what was passed in
      content_type = `file --mime -b #{@tempfile.path}`.split(";")[0]

      # we will also add the extension ourselves based on the above
      # if it's not gif/jpeg/png, it will fail the validation in the upload model
      extension = content_type.match(/gif|jpeg|png/).to_s
      filename += ".#{extension}" if extension

      mime_type = Mime::Type.lookup_by_extension( extension )
   
      ActionDispatch::Http::UploadedFile.new( {
        tempfile: @tempfile,
        content_type: content_type,
        filename: filename,
        type: mime_type
      } )
    end

    def clean_tempfile
      if @tempfile
        @tempfile.close
        @tempfile.unlink
      end
    end
end
