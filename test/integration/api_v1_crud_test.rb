require "test_helper"

class ApiV1CrudTest < ActionDispatch::IntegrationTest
  test "creates, lists, shows, updates and destroys a fuel type" do
    post "/api/v1/tipos_combustivel",
      params: { nome: "Gasolina Comum", tipo: "gasolina", codigo_anp: "320102001", unidade_medida: "litro" },
      as: :json

    assert_response :created
    created = response.parsed_body

    get "/api/v1/tipos_combustivel", params: { limit: 1 }

    assert_response :success
    assert_equal 1, response.parsed_body.size

    get "/api/v1/tipos_combustivel/#{created.fetch("id")}"

    assert_response :success
    assert_equal "Gasolina Comum", response.parsed_body.fetch("nome")

    patch "/api/v1/tipos_combustivel/#{created.fetch("id")}", params: { ativo: false }, as: :json

    assert_response :success
    assert_equal false, response.parsed_body.fetch("ativo")

    delete "/api/v1/tipos_combustivel/#{created.fetch("id")}"

    assert_response :no_content
  end

  test "returns standardized bad request for invalid limit" do
    get "/api/v1/tipos_combustivel", params: { limit: 501 }

    assert_response :bad_request
    assert_equal "bad_request", response.parsed_body.dig("error", "code")
  end

  test "returns standardized not found" do
    get "/api/v1/tipos_combustivel/999999"

    assert_response :not_found
    assert_equal "not_found", response.parsed_body.dig("error", "code")
  end

  test "returns standardized validation errors" do
    post "/api/v1/tipos_combustivel", params: { tipo: "gasolina" }, as: :json

    assert_response :unprocessable_entity
    assert_equal "unprocessable_entity", response.parsed_body.dig("error", "code")
    assert response.parsed_body.dig("error", "details", "nome").present?
  end
end
