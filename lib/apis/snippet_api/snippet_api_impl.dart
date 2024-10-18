part of 'snippet_api.dart';

abstract class SnippetApiService extends ClientService implements SnippetApi {}

class _SnippetApiImpl extends SnippetApiService {
  @override
  Future<Result<List<Snippets>, String>> getAllSnippet({
    required int page,
    String? query,
    int pageSize = 100,
  }) async {
    String buildQuery = '?pageNumber=$page&pageSize=$pageSize&';
    if (query != null) buildQuery += 'query=$query';

    var result = await request(
      requestType: RequestType.get,
      path: '/Snippet/GetAll$buildQuery',
    );

    return result.when(
      (response) {
        if (response['statusCode'] == 200) {
          List<Snippets> snippets = [];
          snippets = List<Snippets>.from(
            response['data']['items'].map((e) => Snippets.fromJson(e)),
          );

          return Success(snippets);
        }
        return Failure(response['message']);
      },
      (error) => Failure(error),
    );
  }
}
