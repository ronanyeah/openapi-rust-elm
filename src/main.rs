use axum::{extract::Json, http::StatusCode, routing::get};
use std::net::SocketAddr;
use utoipa::{OpenApi, ToSchema};
use utoipa_axum::router::OpenApiRouter;

#[derive(OpenApi)]
#[openapi(info(title = "Codegen", version = "1.0.0"))]
struct ApiDoc;

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let cors = tower_http::cors::CorsLayer::new()
        .allow_methods(tower_http::cors::Any)
        .allow_headers(tower_http::cors::Any)
        .allow_origin(tower_http::cors::Any);

    let (router, api) = OpenApiRouter::with_openapi(ApiDoc::openapi())
        .routes(utoipa_axum::routes!(health_handler))
        .routes(utoipa_axum::routes!(stats_handler))
        .layer(tower::ServiceBuilder::new().layer(cors))
        .split_for_parts();

    let router = router.route("/openapi.json", get(|| async { Json(api) }));

    let addr = SocketAddr::from(([0, 0, 0, 0], 8888));

    let listener = tokio::net::TcpListener::bind(addr).await?;

    Ok(axum::serve(listener, router).await?)
}

#[utoipa::path(
    get,
    path = "/healthz",
    responses(
        (status = 200)
    )
)]
async fn health_handler() -> StatusCode {
    StatusCode::OK
}

#[derive(Default, serde::Serialize, ToSchema)]
struct StatsData {
    #[schema(required)]
    data1: Option<Data1>,
    #[schema(required)]
    value1: Option<String>,
}

#[derive(Default, serde::Serialize, ToSchema)]
struct Data1 {
    value2: u8,
    value3: u64,
}

#[utoipa::path(
    get,
    path = "/stats",
    responses(
        (status = 200, body = StatsData)
    )
)]
async fn stats_handler() -> Json<StatsData> {
    Json(Default::default())
}
