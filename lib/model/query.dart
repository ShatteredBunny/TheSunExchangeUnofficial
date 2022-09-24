class Query {
  final String? operationName;
  final String query;
  final Object variables;

  Query(this.query, this.variables, {this.operationName});

  Map<String, dynamic> toJson() {
    return {
      'operationName': operationName,
      'query': query,
      'variables': variables,
    };
  }
}
