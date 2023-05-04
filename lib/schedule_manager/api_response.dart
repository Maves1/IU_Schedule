enum LoadStatus { loading, success, failure }

class APIResponse<T> {
  LoadStatus status;
  T? data;

  APIResponse.loading() : status = LoadStatus.loading;
  APIResponse.success(this.data) : status = LoadStatus.success;
  APIResponse.failure() : status = LoadStatus.failure;
}
