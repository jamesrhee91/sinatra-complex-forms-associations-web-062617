class PetsController < ApplicationController

  get '/pets' do
    @pets = Pet.all
    erb :'/pets/index'
  end

  get '/pets/new' do
    @owners = Owner.all
    erb :'/pets/new'
  end

  post '/pets' do
    if !params["owner"]
      @owner = Owner.create(name: params["owner_name"])
      @pet = Pet.create(name: params["pet"]["name"], owner_id: @owner.id)
    else
      @pet = Pet.create(name: params["pet"]["name"], owner_id: params["owner"]["id"])
      @owner = Owner.find(params["owner"]["id"])
    end
    @owner.pets << @pet
    @owner.save
    redirect to "pets/#{@pet.id}"
  end

  get '/pets/:id/edit' do
    @pet = Pet.find(params[:id])
    erb :'/pets/edit'
  end

  get '/pets/:id' do
    @pet = Pet.find(params[:id])
    erb :'/pets/show'
  end

  post '/pets/:id' do
    @pet = Pet.find(params[:id])
    if params["owner"]["name"].present?
      @owner = Owner.create(name: params["owner"]["name"])
    else
      @owner = Owner.find(params["pet"]["owner_id"])
    end
      @pet.update(params[:pet])
      @pet.update(owner: @owner)
    redirect to "pets/#{@pet.id}"
  end
end
