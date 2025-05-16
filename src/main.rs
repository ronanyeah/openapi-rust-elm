use axum::{
    extract::{Json, State},
    http::StatusCode,
};
use std::sync::Arc;
use tokio::sync::Mutex;
use utoipa::{OpenApi, ToSchema};
use utoipa_axum::router::OpenApiRouter;

#[derive(OpenApi)]
#[openapi(info(title = "Codegen", version = "1.0.0"))]
struct ApiDoc;

#[derive(Clone)]
struct App {
    count: Arc<Mutex<usize>>,
}

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let state = App {
        count: Arc::new(Mutex::new(0)),
    };
    let router = create_router(state);

    let addr = std::net::SocketAddr::from(([0, 0, 0, 0], 8888));

    let listener = tokio::net::TcpListener::bind(addr).await?;

    axum::serve(listener, router).await?;

    Ok(())
}

fn create_router(state: App) -> axum::Router<()> {
    let cors = tower_http::cors::CorsLayer::new()
        .allow_methods(tower_http::cors::Any)
        .allow_headers(tower_http::cors::Any)
        .allow_origin(tower_http::cors::Any);

    let (router, api) = OpenApiRouter::with_openapi(ApiDoc::openapi())
        .routes(utoipa_axum::routes!(health_handler))
        .routes(utoipa_axum::routes!(stats_handler))
        .routes(utoipa_axum::routes!(bump_handler))
        .routes(utoipa_axum::routes!(body_handler))
        .layer(tower::ServiceBuilder::new().layer(cors))
        .with_state(state)
        .split_for_parts();

    let router_with_schema =
        router.route("/openapi.json", axum::routing::get(|| async { Json(api) }));

    router_with_schema
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

#[utoipa::path(
    get,
    path = "/bump",
    responses(
        (status = 200, body = usize)
    )
)]
async fn bump_handler(State(app): State<App>) -> Json<usize> {
    let mut count = app.count.lock().await;
    *count += 1;
    Json(*count)
}

#[derive(serde::Deserialize, ToSchema)]
struct Params {
    name: String,
    age: usize,
}

#[utoipa::path(
    post,
    path = "/body",
    responses(
        (status = 200, body = bool)
    )
)]
async fn body_handler(State(_app): State<App>, Json(params): Json<Params>) -> Json<bool> {
    let _ = params.name;
    let _ = params.age;
    Json(true)
}
