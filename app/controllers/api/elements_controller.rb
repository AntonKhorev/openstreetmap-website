module Api
  class ElementsController < ApiController
    # Dump the details on many elements whose ids are given in the "nodes"/"ways"/"relations" parameter.
    def index
      raise OSM::APIBadUserInput, "The parameter #{controller_name} is required, and must be of the form #{controller_name}=id[,id[,id...]]" unless params[controller_name]

      ids = params[controller_name].split(",").collect(&:to_i)

      raise OSM::APIBadUserInput, "No #{controller_name} were given to search for" if ids.empty?

      current_model = controller_name.classify.constantize
      instance_variable_set :"@#{controller_name}", current_model.find(ids)

      # Render the result
      respond_to do |format|
        format.xml
        format.json
      end
    end
  end
end
