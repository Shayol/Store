require 'rails_helper'

RSpec.describe BooksController, type: :controller do

  let(:book) { create :book }

  describe "GET index" do
    it "assigns @books" do
      get :index
      expect(assigns(:books)).to eq([book])
    end

    it "assigns @categories" do
      get :index
      category1 = create :category
      category2 = create :category
      expect(assigns(:categories)).to eq([category1, category2])
    end

    it "renders the index template" do
      get :index
      expect(response).to render_template("index")
    end
  end

  describe "GET show" do
    before { get :show, id: book.id }

    it "assigns @book" do
      expect(assigns(:book)).to eq book
    end

    it "renders the show template" do
      expect(response).to render_template("show")
    end
  end

  describe "search" do
    it "assigns @books to array found by search keywords" do
      book1 = create :book
      book2 = create :book

      post :search, search: book2.title
      expect(assigns(:books)).to eq([book2])
    end

    it "redirects to index template" do
      post :search
      expect(response).to render_template("index")
    end
  end

  describe "POST add_to_order" do
    it "calls #order_book"

    it "redirects to cart with notice" do
      post :add_to_order, id: book.id, :add_to_order => {:quantity => 1 }
      expect(response).to redirect_to cart_path
      expect(flash[:notice]).to eq("Book successfully added")
    end
  end

end
