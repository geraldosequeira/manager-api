require 'rails_helper'

RSpec.describe 'Tasks API', type: :request do
  
  before { host! 'api.taskmanager.test' }

  let!(:user) { create(:user) }

  let(:headers) do 
    {
      'Content-Type' => Mime[:json].to_s,
      'Accept' => 'application/vnd.taskmanager.v1',
      'Authorization' => user.auth_token
    }
  end

  describe 'GET /tasks' do
    before do
      create_list(:task, 5, user: user)
      get "/tasks", params: {}, headers: headers
    end

    it 'returns tasks of user' do
      expect(json_body[:tasks].count).to eq(5)
    end

    it 'returns http status code: OK ' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /tasks/:id' do
    let(:task) { create(:task, user: user) }
    
    before { get "/tasks/#{task.id}", params: {}, headers: headers }
    
    it 'returns the data json for task' do
      expect(json_body[:title]).to eq(task.title)
    end

    it 'returns http status code: OK' do
      expect(response).to have_http_status(200)
    end

  end

  describe 'POST /tasks' do

    before { post '/tasks', params: { task: task_params }.to_json, headers: headers }

    context 'when the params are valid' do
      let(:task_params) { attributes_for(:task) }

      it 'save the task in the database' do
        expect( Task.find_by(title: task_params[:title])).not_to be_nil
      end

      it 'returns the json for created task' do 
        expect(json_body[:title]).to eq(task_params[:title])
      end

      it 'assigns the created task to the current user' do
        expect(json_body[:user_id]).to eq(user.id)
      end

      it 'returns http status code: Created' do
        expect(response).to have_http_status(201)  
      end
    end

    context 'when the params are invalid' do 
      let(:task_params) { attributes_for(:task, title: ' ') }

      it 'return the json error for title' do 
        expect(json_body[:errors]).to have_key(:title)
      end

      it 'does not save the task in the database' do
        expect(Task.find_by(title: task_params[:title])).to be_nil
      end

      it 'returns http status code: Unprocessable Entity' do
        expect(response).to have_http_status(422)
      end

    end

  end

  describe 'PUT /task/:id' do

    let(:task) { create(:task, user: user) }

    before do
      put "/tasks/#{task.id}", params: { task: task_params }.to_json, headers: headers
    end
    
    context 'when the params are valid' do 
      let(:task_params) { attributes_for(:task) }

      it 'return then json for updated task' do 
        expect(json_body[:title]).to eq(task_params[:title])
      end

      it 'updates task in data base' do 
        expect(Task.find_by(title: task_params[:title])).not_to be_nil
      end

      it 'return http status code: OK' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the params are invalid' do
      let(:task_params) { attributes_for(:task, title: ' ') }

      it 'returns the data json erro for title' do
        expect(json_body[:errors]).to have_key(:title)
      end

      it 'does not update task in the database' do 
        expect( Task.find_by(title: task_params[:title]) ).to be_nil 
      end

      it 'returns http status code: Unprocessable Entity' do
        expect(response).to have_http_status(422)
      end
    end

  end

  describe 'DELETE /tasks/:id' do 
    let!(:task) { create(:task, user_id: user.id) }

    before do
      delete "/tasks/#{task.id}", params: {}, headers: headers
    end

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end

    it 'removes the task from the database' do
      expect { Task.find(task.id) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

end