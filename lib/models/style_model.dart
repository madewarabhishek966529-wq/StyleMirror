/// Style representation (Hairstyle or Beard style)
class StyleModel {
  final String id;
  final String type; // 'hair' or 'beard'
  final String name;
  final String promptHint;
  final String thumbUrl;
  final String category;
  final List<String> tags;
  final int sortOrder;

  const StyleModel({
    required this.id,
    required this.type,
    required this.name,
    required this.promptHint,
    required this.thumbUrl,
    required this.category,
    this.tags = const [],
    this.sortOrder = 0,
  });

  bool get isHair => type == 'hair';
  bool get isBeard => type == 'beard';

  factory StyleModel.fromJson(Map<String, dynamic> json) {
    return StyleModel(
      id: json['id'] as String,
      type: json['type'] as String,
      name: json['name'] as String,
      promptHint: json['prompt_hint'] as String? ?? json['promptHint'] as String? ?? '',
      thumbUrl: json['thumb_url'] as String? ?? json['thumbUrl'] as String? ?? '',
      category: json['category'] as String? ?? 'Classic',
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'name': name,
      'prompt_hint': promptHint,
      'thumb_url': thumbUrl,
      'category': category,
      'tags': tags,
      'sort_order': sortOrder,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StyleModel && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
