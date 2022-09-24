class Project {
  final String urlSlug;
  final String videoLink;
  final ProjectImage mainImage;
  final ProjectImage? brochure;
  final String summary;
  final bool? featured;

  Project({
    required this.urlSlug,
    required this.videoLink,
    required this.mainImage,
    required this.brochure,
    required this.summary,
    required this.featured,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      urlSlug: json['urlSlug'],
      videoLink: json['videoLink'],
      mainImage: ProjectImage.fromJson(json['mainImage']),
      brochure: json['brochure'] == null
          ? null
          : ProjectImage.fromJson(json['brochure']),
      summary: json['summary'],
      featured: json['featured'],
    );
  }
}

class ProjectImage {
  final String url;
  final String hash;

  ProjectImage({
    required this.url,
    required this.hash,
  });

  factory ProjectImage.fromJson(Map<String, dynamic> json) {
    return ProjectImage(
      url: json['url'],
      hash: json['hash'],
    );
  }
}
