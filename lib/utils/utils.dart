String buildQueryString(Map<String, dynamic> queries) {
  String queryString = '';

  queries.forEach((key, value) {
    if (value != null) {
      if (queryString.isEmpty) {
        queryString += '?$key=$value';
      } else {
        queryString += '&$key=$value';
      }
    }
  });

  return queryString;
}
