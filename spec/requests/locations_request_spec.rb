require 'rails_helper'

RSpec.describe "Locations", type: :request do
  describe 'GET #index' do
    before(:example) do
      @user = create(:user)
      @first_location = create(:location, user_id: @user.id)
      @last_location = create(:location, user_id: @user.id)
      @photo = create(:photo, user_id: @user.id, location_id: @first_location.id)
      @photo.image.attach(io: File.open(Rails.root.join('spec', 'factories', 'images', 'icon.jpg')), filename: 'icon.jpg', content_type: 'image/jpeg')
      @photol = create(:photo, user_id: @user.id, location_id: @last_location.id)
      @photol.image.attach(io: File.open(Rails.root.join('spec', 'factories', 'images', 'icon.jpg')), filename: 'icon.jpg', content_type: 'image/jpeg')
      get '/locations'
      @json_response = JSON.parse(response.body)
    end

    it 'returns http success' do
      expect(response).to have_http_status(200)
    end

    it 'JSON response contains the correct number of entries' do
      expect(@json_response["locations"].length).to eq(2)
    end

    it 'JSON response body contains expected attributes' do
      expect(@json_response["locations"][0]).to include({
        'name' => @first_location.name,
        'tagline' => @first_location.tagline,
        'description' => @first_location.description,
      }) 
    end
  end

  describe 'POST #create' do
    context 'when the location is valid' do
      before(:example) do
        @user = User.create(username:"T",password:"pwd",email:"t@t.com")
        @location_params = attributes_for(:location).merge(user_id: @user.id)
        post '/locations', params: { location: @location_params }, headers: authenticated_header
      end

      it 'returns http created' do
        expect(response).to have_http_status(:created)
      end

      it 'saves the location to the database' do
        expect(Location.last.name).to eq(@location_params[:name])
      end
    end

    context 'when the location has invalid attributes' do
      before(:example) do
        @user = build(:user)
        @location_params = attributes_for(:location, :invalid)
        post '/locations', params: { location: @location_params }, headers: authenticated_header
        @json_response = JSON.parse(response.body)
      end

      it 'returns http unprocessable entity' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns the correct number of errors' do
        expect(@json_response['errors'].count).to eq(1)
      end

      it 'errors contains the correct message' do
        expect(@json_response['errors'][0]).to eq("Name can't be blank")
      end
    end
  end
  
  describe 'PUT #update' do
    context 'when the params are valid' do
      before(:example) do
        @user = User.create(username:"T",password:"pwd",email:"t@t.com")
        @location = create(:location, user_id: @user.id)
        @updated_name = 'Updated location'
        put "/locations/#{@location.id}", params: { location: { name: @updated_name } }, headers: authenticated_header
      end

      it 'has a http ok response status' do
        expect(response).to have_http_status(:ok)
      end

      it 'updates the location in the database' do
        expect(Location.find(@location.id).name).to eq(@updated_name)
      end
    end

    context 'when the params are invalid' do
      before(:example) do
        @user = User.create(username:"T",password:"pwd",email:"t@t.com")
        @location = create(:location, user_id: @user.id)
        put "/locations/#{@location.id}", params: { location: { name: nil } }, headers: authenticated_header
        @json_response = JSON.parse(response.body)
      end

      it 'returns a unprocessable entity response' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'has the correct number of errors' do
        expect(@json_response['errors'].count).to eq(1)
      end
    end
  end

  describe 'DELETE #destroy' do
    before(:example) do
        @user = User.create(username:"T",password:"pwd",email:"t@t.com")
        @location = create(:location, user_id: @user.id)
      delete "/locations/#{@location.id}", headers: authenticated_header
    end

    it 'has a http no content response status' do
      expect(response).to have_http_status(:ok)
    end

    it 'removes the location from the database' do
      expect(Location.count).to eq(0)
    end
  end
end