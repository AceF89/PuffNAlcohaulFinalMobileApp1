import 'package:alcoholdeliver/model/snippets.dart';
import 'package:alcoholdeliver/services/client/client_service.dart';
import 'package:alcoholdeliver/services/client/result.dart';

part 'snippet_api_impl.dart';

abstract class SnippetApi {
  static final SnippetApi _instance = _SnippetApiImpl();

  static SnippetApi get instance => _instance;

  Future<Result<List<Snippets>, String>> getAllSnippet({
    required int page,
    String? query,
    int pageSize = 100,
  });
}
